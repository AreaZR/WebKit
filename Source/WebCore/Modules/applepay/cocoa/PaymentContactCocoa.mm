/*
 * Copyright (C) 2016-2018 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "config.h"
#import "PaymentContact.h"

#if ENABLE(APPLE_PAY)

#import "ApplePayPaymentContact.h"
#import <Contacts/Contacts.h>
#import <pal/cocoa/PassKitSoftLink.h>
#import <wtf/SoftLinking.h>
#import <wtf/text/StringBuilder.h>

SOFT_LINK_FRAMEWORK(Contacts)
SOFT_LINK_CLASS(Contacts, CNMutablePostalAddress)
SOFT_LINK_CLASS(Contacts, CNPhoneNumber)

namespace WebCore {

static RetainPtr<PKContact> convert(unsigned version, const ApplePayPaymentContact& contact)
{
    auto result = adoptNS([PAL::allocPKContactInstance() init]);

    NSString *familyName = nil;
    NSString *phoneticFamilyName = nil;
    if (!contact.familyName.isEmpty()) {
        familyName = contact.familyName;
        if (version >= 3 && !contact.phoneticFamilyName.isEmpty())
            phoneticFamilyName = contact.phoneticFamilyName;
    }

    NSString *givenName = nil;
    NSString *phoneticGivenName = nil;
    if (!contact.givenName.isEmpty()) {
        givenName = contact.givenName;
        if (version >= 3 && !contact.phoneticGivenName.isEmpty())
            phoneticGivenName = contact.phoneticGivenName;
    }

    if (familyName || givenName) {
        auto name = adoptNS([[NSPersonNameComponents alloc] init]);
        name.familyName = familyName;
        name.givenName = givenName;
        if (phoneticFamilyName || phoneticGivenName) {
            auto phoneticName = adoptNS([[NSPersonNameComponents alloc] init]);
            phoneticName.familyName = phoneticFamilyName;
            phoneticName.givenName = phoneticGivenName;
            name.phoneticRepresentation = phoneticName.get();
        }
        result.name = name.get();
    }

    if (!contact.emailAddress.isEmpty())
        result.emailAddress = contact.emailAddress;

    if (!contact.phoneNumber.isEmpty())
        result.phoneNumber = adoptNS([allocCNPhoneNumberInstance() initWithStringValue:contact.phoneNumber]).get();

    if (contact.addressLines && !contact.addressLines->isEmpty()) {
        auto address = adoptNS([allocCNMutablePostalAddressInstance() init]);

        StringBuilder builder;
        for (unsigned i = 0; i < contact.addressLines->size(); ++i) {
            builder.append(contact.addressLines->at(i));
            if (i != contact.addressLines->size() - 1)
                builder.append('\n');
        }

        // FIXME: StringBuilder should hava a toNSString() function to avoid the extra String allocation.
        address.street = builder.toString();

        if (!contact.subLocality.isEmpty())
            address.subLocality = contact.subLocality;
        if (!contact.locality.isEmpty())
            address.city = contact.locality;
        if (!contact.postalCode.isEmpty())
            address.postalCode = contact.postalCode;
        if (!contact.subAdministrativeArea.isEmpty())
            address.subAdministrativeArea = contact.subAdministrativeArea;
        if (!contact.administrativeArea.isEmpty())
            address.state = contact.administrativeArea;
        if (!contact.country.isEmpty())
            address.country = contact.country;
        if (!contact.countryCode.isEmpty())
            address.ISOCountryCode = contact.countryCode;

        result.postalAddress = address.get();
    }

    return result;
}

static ApplePayPaymentContact convert(unsigned version, PKContact *contact)
{
    ASSERT(contact);

    ApplePayPaymentContact result;

    result.phoneNumber = contact.phoneNumber.stringValue;
    result.emailAddress = contact.emailAddress;

    NSPersonNameComponents *name = contact.name;
    result.givenName = name.givenName;
    result.familyName = name.familyName;
    if (name)
        result.localizedName = [NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:name style:NSPersonNameComponentsFormatterStyleDefault options:0];

    if (version >= 3) {
        NSPersonNameComponents *phoneticName = name.phoneticRepresentation;
        result.phoneticGivenName = phoneticName.givenName;
        result.phoneticFamilyName = phoneticName.familyName;
        if (phoneticName)
            result.localizedPhoneticName = [NSPersonNameComponentsFormatter localizedStringFromPersonNameComponents:name style:NSPersonNameComponentsFormatterStyleDefault options:NSPersonNameComponentsFormatterPhonetic];
    }

    CNPostalAddress *postalAddress = contact.postalAddress;
    if (postalAddress.street.length)
        result.addressLines = String(postalAddress.street).split('\n');
    result.subLocality = postalAddress.subLocality;
    result.locality = postalAddress.city;
    result.postalCode = postalAddress.postalCode;
    result.subAdministrativeArea = postalAddress.subAdministrativeArea;
    result.administrativeArea = postalAddress.state;
    result.country = postalAddress.country;
    result.countryCode = postalAddress.ISOCountryCode;

    return result;
}

PaymentContact::PaymentContact() = default;

PaymentContact::PaymentContact(RetainPtr<PKContact>&& pkContact)
    : m_pkContact { WTFMove(pkContact) }
{
}

PaymentContact::~PaymentContact() = default;

PaymentContact PaymentContact::fromApplePayPaymentContact(unsigned version, const ApplePayPaymentContact& contact)
{
    return PaymentContact(convert(version, contact).get());
}

ApplePayPaymentContact PaymentContact::toApplePayPaymentContact(unsigned version) const
{
    return convert(version, m_pkContact.get());
}

PKContact *PaymentContact::pkContact() const
{
    return m_pkContact.get();
}

}

#endif
