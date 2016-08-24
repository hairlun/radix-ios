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

#import "BatteryServiceModel.h"

/*!
 *  @class BatteryServiceModel
 *
 *  @discussion Class to handle the battery service related operations
 *
 */
@interface BatteryServiceModel()<cbCharacteristicManagerDelegate>
{
    void(^cbCharacteristicDiscoverHandler)(BOOL success,NSError *error);
    BOOL isCharacteristicRead;
}

@end


@implementation BatteryServiceModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.batteryServiceDict = [[NSMutableDictionary alloc] init];
        [self.batteryServiceDict setValue:@" " forKey:[NSString stringWithFormat:@"%@",[[CBManager sharedManager] myService]]];
    }
    return self;
}


/*!
 *  @method startDiscoverChar
 *
 *  @discussion Discovers the specified characteristics of a service..
 */

-(void)startDiscoverCharacteristicsWithCompletionHandler:(void (^)(BOOL success,NSError *error))handler

{
    cbCharacteristicDiscoverHandler = handler;
    [[CBManager sharedManager] setCbCharacteristicDelegate:self];
     [[[CBManager sharedManager] myPeripheral] discoverCharacteristics:nil forService:[[CBManager sharedManager] myService]];

}


-(void) readBatteryLevel
{
    if (_batteryCharacterisic != nil)
    {
        isCharacteristicRead = YES;
        [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:BATTERY_LEVEL_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:BATTERY_LEVEL_CHARACTERISTIC_UUID] descriptor:nil operation:READ_REQUEST];
        
        [[[CBManager sharedManager] myPeripheral] readValueForCharacteristic:_batteryCharacterisic];
    }
}


/*!
 *  @method updateCharacteristicWithHandler:
 *
 *  @discussion Sets notifications or indications for the value of a specified characteristic.
 */

-(void)startUpdateCharacteristic
{

    if (_batteryCharacterisic != nil)
    {
        [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:BATTERY_LEVEL_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:BATTERY_LEVEL_CHARACTERISTIC_UUID] descriptor:nil operation:START_NOTIFY];
        
        [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:_batteryCharacterisic];
    }
}

/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */


-(void)stopUpdate
{
    if (_batteryCharacterisic != nil)
    {
        if (_batteryCharacterisic.isNotifying)
        {
            [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:_batteryCharacterisic];
            [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:BATTERY_LEVEL_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:BATTERY_LEVEL_CHARACTERISTIC_UUID] descriptor:nil operation:STOP_NOTIFY];
        }
    }
}




#pragma mark - characteristicManager delegate

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:BATTERY_LEVEL_SERVICE_UUID])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Checking for the required characteristic
            if ([aChar.UUID isEqual:BATTERY_LEVEL_CHARACTERISTIC_UUID])
            {
                _batteryCharacterisic = aChar;
                cbCharacteristicDiscoverHandler(YES,nil);
            }
           
        }
    }
    else
        cbCharacteristicDiscoverHandler(NO,error);
}

/*!
 *  @method peripheral: didUpdateValueForCharacteristic: error:
 *
 *  @discussion Method invoked when the characteristic value changes
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if(error == nil )
    {
        [self handleBatteryCharacteristicValueWithChar:characteristic];
    }
}

/*!
 *  @method handleBatteryCharacteristicValueWithChar:
 *
 *  @discussion Method to handle the characteristic value
 *
 */

-(void) handleBatteryCharacteristicValueWithChar:(CBCharacteristic *) characteristic
{
    if ([characteristic.UUID isEqual:BATTERY_LEVEL_CHARACTERISTIC_UUID] && characteristic.value)
    {
        [self getBatteryData:characteristic];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateBatteryUI)])
    {
        [_delegate updateBatteryUI];
    }

}


/*!
 *  @method getBatteryData:
 *
 *  @discussion Method to get the Battery Level information
 *
 */

- (void)getBatteryData:(CBCharacteristic *)characteristic
{
    NSData *data = [characteristic value];
    const uint8_t *reportData = [data bytes];
    NSString *levelString=[NSString stringWithFormat:@"%d",reportData[0]];
    
    if (!isCharacteristicRead)
    {
        [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",NOTIFY_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
    }
    else
    {
        [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",READ_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
        isCharacteristicRead = NO;
    }
    
    
    [self.batteryServiceDict setValue:levelString forKey:[NSString stringWithFormat:@"%@",characteristic.service]];
}


@end
