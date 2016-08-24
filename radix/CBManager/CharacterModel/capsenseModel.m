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
#import "capsenseModel.h"
#import "Constants.h"

/*!
 *  @class capsenseModel
 *
 *  @discussion Class to handle the capsense service related operations
 *
 */

@interface capsenseModel() <cbCharacteristicManagerDelegate>
{
    void(^cbCharacteristicDiscoverHandler)(BOOL success,CBService *service, NSError *error);
    void(^cbCharacteristicHandler)(BOOL success, NSError *error);

    CBUUID *charUUID;
    CBCharacteristic *capsenseCharacteristic;
}

@end

@implementation capsenseModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[CBManager sharedManager] setCbCharacteristicDelegate:self];
    }
    return self;
}



/*!
 *  @method startDiscoverChar:withCompletionHandler
 *
 *  @discussion Discovers the specified characteristics of a service..
 */

-(void)startDiscoverCharacteristicWithUUID:(CBUUID *)UUID withCompletionHandler:(void (^) (BOOL success,CBService *service, NSError *error))handler
{
  
    cbCharacteristicDiscoverHandler = handler;
    charUUID = UUID;
    [[[CBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:[[CBManager sharedManager] myService]];

}

/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */

-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler
{
    cbCharacteristicHandler = handler;
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:capsenseCharacteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:capsenseCharacteristic.UUID] descriptor:nil operation:START_NOTIFY];
    [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:capsenseCharacteristic];
}

/*!
 *  @method stopUpdate
 *
 *  @discussion stop notifications or indications for the value of a specified characteristic.
 */


-(void)stopUpdate
{
    cbCharacteristicHandler = nil;
    if (capsenseCharacteristic != nil)
    {
        if (capsenseCharacteristic.isNotifying)
        {
            [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:capsenseCharacteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:capsenseCharacteristic.UUID] descriptor:nil operation:STOP_NOTIFY];
            [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:capsenseCharacteristic];

        }
    }
}





#pragma mark - CBCharacteristic Manager delegate

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:CAPSENSE_SERVICE_UUID] || [service.UUID isEqual:CUSTOM_CAPSENSE_SERVICE_UUID])
    {
        if (charUUID == nil && cbCharacteristicDiscoverHandler != nil)
        {
            cbCharacteristicDiscoverHandler(YES,service,nil);

        }
        
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if (charUUID != nil)
            {
                // Checking for the required characteristic
                if ([aChar.UUID isEqual:charUUID])
                {
                    capsenseCharacteristic = aChar;
                    cbCharacteristicDiscoverHandler(YES,nil,nil);
                }
            }
        }
        cbCharacteristicDiscoverHandler(NO,nil,nil);

    }
    else
    {
        cbCharacteristicDiscoverHandler(NO,nil,nil);
    }
}

/*!
 *  @method didUpdateValueForCharacteristic
 *
 *  @discussion Parse the CapSense value from the characteristic.
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSData *data = characteristic.value;
    uint8_t *dataPointer = (uint8_t *)[data bytes];
    
    /**
     * Parse the CapSense proximity value from the characteristic
     */
    if ([characteristic.UUID isEqual:CAPSENSE_PROXIMITY_CHARACTERISTIC_UUID] || [characteristic.UUID isEqual:CUSTOM_CAPSENSE_PROXIMITY_CHARACTERISTIC_UUID])
    {
        uint8_t value = dataPointer[0];
        _proximityValue = value;
        cbCharacteristicHandler(YES,nil);
    }
    /**
     * Parse the CapSense slider value from the characteristic
     */
    else if ([characteristic.UUID isEqual:CAPSENSE_SLIDER_CHARACTERISTIC_UUID] || [characteristic.UUID isEqual:CUSTOM_CAPSENSE_SLIDER_CHARACTERISTIC_UUID])
    {
        uint8_t value = dataPointer[0];
        
        _capsenseSliderValue = value;
        cbCharacteristicHandler(YES,nil);
    }
    /**
     * Parse the CapSense buttons value from the characteristic
     */
   
    else if ([characteristic.UUID isEqual:CAPSENSE_BUTTON_CHARACTERISTIC_UUID] || [characteristic.UUID isEqual:CUSTOM_CAPSENSE_BUTTONS_CHARACTERISTIC_UUID])
    {
        uint8_t numberOfButtons = dataPointer[0];
        _capsenseButtonCount = numberOfButtons;
        
        // Getting the 16 bit button status flag        
        _capsenseButtonFirstStatusFlag = dataPointer[2];
        _capsenseButtonSecondStatusFlag = dataPointer[1];
        cbCharacteristicHandler(YES,nil);        
    }
    else
    {
        cbCharacteristicHandler(NO,error);
    }
    
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",NOTIFY_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
}



@end
