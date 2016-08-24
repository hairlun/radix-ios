/*
 * Copyright Cypress Semiconductor Corporation, 2014-2015 All rights reserved.
 *
 * This software, associated documentation and materials ("Software") is
 * owned by Cypress Semiconductor Corporation ("Cypress") and is
 * protected by and subject to worldwide patent protection (UnitedStates and foreign), United States copyright laws and international
 * treaty provisions. Therefore, unless otherwise specified in a separate license agreement between you and Cypress, this Software
 * must be treated like any other copyrighted material. Reproduction,
 * modification, translation, compilation, or representation of this
 * Software in any other form (e.g., paper, magnetic, optical, silicon)
 * is prohibited without Cypress's express written permission.
 *
 * Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY
 * KIND, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
 * NONINFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE. Cypress reserves the right to make changes
 * to the Software without notice. Cypress does not assume any liability
 * arising out of the application or use of Software or any product or
 * circuit described in the Software. Cypress does not authorize its
 * products for use as critical components in any products where a
 * malfunction or failure may reasonably be expected to result in
 * significant injury or death ("High Risk Product"). By including
 * Cypress's product in a High Risk Product, the manufacturer of such
 * system or application assumes all risk of such use and in doing so
 * indemnifies Cypress against all liability.
 *
 * Use of this Software may be limited by and subject to the applicable
 * Cypress software license agreement.
 *
 *
 */
#import "DevieInformationModel.h"
#import "CBManager.h"
#import "Constants.h"
#import "Utilities.h"

/*!
 *  @class DevieInformationModel
 *
 *  @discussion Class to handle the device information service related operations
 *
 */

@interface DevieInformationModel ()<cbCharacteristicManagerDelegate>
{
    void(^cbCharacteristicDiscoverHandler)(BOOL success, NSError *error);
    void(^cbCharacteristicHandler)(BOOL success, NSError *error);
    
    NSArray *deviceInfoCharArray;
    int charCount;
}

@end


@implementation DevieInformationModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (!_deviceInfoCharValueDictionary)
        {
            _deviceInfoCharValueDictionary = [NSMutableDictionary dictionary];
        }
        charCount = 0;
    }
    return self;
}


/*!
 *  @method startDiscoverChar:
 *
 *  @discussion Discovers the specified characteristics of a service..
 */
-(void)startDiscoverChar:(void (^) (BOOL success, NSError *error))handler
{
    cbCharacteristicDiscoverHandler = handler;
    
    [[CBManager sharedManager] setCbCharacteristicDelegate:self];
    [[[CBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:[[CBManager sharedManager] myService]];
    
}

/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */


-(void) discoverCharacteristicValues:(void(^)(BOOL success, NSError *error))handler
{
    cbCharacteristicHandler = handler;
    
    for (CBCharacteristic *aChar in deviceInfoCharArray)
    {
        [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:DEVICE_INFO_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:aChar.UUID] descriptor:nil operation:READ_REQUEST];
        
        [[[CBManager sharedManager] myPeripheral] readValueForCharacteristic:aChar];
    }
}



#pragma mark - CBCharacteristic manager delegate

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:DEVICE_INFO_SERVICE_UUID])
    {
        deviceInfoCharArray = service.characteristics;
        cbCharacteristicDiscoverHandler(YES,nil);
    }
    else
    {
        cbCharacteristicDiscoverHandler(NO,error);
    }
}

/*!
 *  @method didUpdateValueForCharacteristic:
 *
 *  @discussion  Method to get the basic information from the characteristic
 */


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *charData = characteristic.value;
    
    /* Read the name of the manufacturer of the device from characteristic
     */
    if ([characteristic.UUID isEqual:DEVICE_MANUFACTURER_NAME_CHARACTERISTIC_UUID])
    {
         NSString *manufactureName = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (manufactureName != nil)
        {
            [_deviceInfoCharValueDictionary setObject:manufactureName forKey:MANUFACTURER_NAME];
        }
    }
    /* Read the model number that is assigned by the device vendor from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_MODEL_NUMBER_CHARACTERISTIC_UUID])
    {
        NSString *modelNumberString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (modelNumberString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:modelNumberString forKey:MODEL_NUMBER];
        }
    }
    /* Read the serial number for a particular instance of the device from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_SERIAL_NUMBER_CHARACTERISTIC_UUID])
    {
        NSString *serialNumberString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (serialNumberString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:serialNumberString forKey:SERIAL_NUMBER];
        }
    }
    /* Read the hardware revision for the hardware within the device from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_HARDWARE_REVISION_CHARACTERISTIC_UUID])
    {
        NSString *hardwareRevisionString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (hardwareRevisionString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:hardwareRevisionString forKey:HARDWARE_REVISION];
        }
    }
    else if ([characteristic.UUID isEqual:DEVICE_FIRMWARE_REVISION_CHARACTERISTIC_UUID])
    {
        NSString *firmwareRevisionString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (firmwareRevisionString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:firmwareRevisionString forKey:FIRMWARE_REVISION];
        }
    }
    /* Read the software revision for the software within the device from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_SOFTWARE_REVISION_CHARACTERISTIC_UUID])
    {
        
        NSString *softwareRevisionString = [[NSString alloc] initWithData:charData encoding:NSUTF8StringEncoding];
        
        if (softwareRevisionString != nil)
        {
            [_deviceInfoCharValueDictionary setObject:softwareRevisionString forKey:SOFTWARE_REVISION];
        }
    }
    /* Read a structure containing an Organizationally Unique Identifier (OUI) followed by a manufacturer-defined identifier and is unique for each individual instance of the product from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_SYSTEMID_CHARACTERISTIC_UUID])
    {
        
        NSString *systemID = [NSString stringWithFormat:@"%@",characteristic.value];
        
        if (systemID != nil)
        {
            [_deviceInfoCharValueDictionary setObject:systemID forKey:SYSTEM_ID];
        }

    }
    /* Read the regulatory and certification information for the product in a list defined in IEEE 11073-20601 from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_CERTIFICATION_DATALIST_CHARACTERISTIC_UUID])
    {
        
        NSString *certificationDataList = [NSString stringWithFormat:@"%@",charData];
        
        if (certificationDataList != nil)
        {
            [_deviceInfoCharValueDictionary setObject:certificationDataList forKey:REGULATORY_CERTIFICATION_DATA_LIST];
        }
    }
    /* Read a set of values used to create a device ID value that is unique for this device from characteristic
     */
    else if ([characteristic.UUID isEqual:DEVICE_PNPID_CHARACTERISTIC_UUID])
    {
        
        NSString *pnpID = [NSString stringWithFormat:@"%@",characteristic.value];
        
        if (pnpID != nil)
        {
            [_deviceInfoCharValueDictionary setObject:pnpID forKey:PNP_ID];

        }
    }
    else
    {
        NSLog(@"Unknown characteristic");
    }
    
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:DEVICE_INFO_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",READ_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:charData]]];
    
    charCount ++;
    
    if (charCount == deviceInfoCharArray.count)
    {
        cbCharacteristicHandler(YES,nil);
    }
    
}




@end
