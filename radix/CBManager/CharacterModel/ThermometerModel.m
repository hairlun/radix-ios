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

#import "ThermometerModel.h"
#import "CBManager.h"

/*!
 *  @class ThermometerModel
 *
 *  @discussion Class to handle the thermometer service related operations
 *
 */


@interface ThermometerModel () <cbCharacteristicManagerDelegate>
{
    void (^cbCharacteristicHandler)(BOOL success, NSError *error);
    void (^cbCharacteristicDiscoverHandler)(BOOL success, NSError *error);
    CBCharacteristic *RSCCharacter;
    
}

@end

@implementation ThermometerModel

@synthesize tempStringValue;
@synthesize mesurementType;
@synthesize timeStampString;
@synthesize tempType;


- (instancetype)init
{
    self = [super init];
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
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler
{
    cbCharacteristicHandler = handler;
    
    
}

/*!
 *  @method stopUpdate
 *
 *  @discussion Stop notifications or indications for the value of a specified characteristic.
 */


-(void)stopUpdate
{
    cbCharacteristicHandler = nil;
    
    if ([[[CBManager sharedManager] myService].UUID isEqual:THM_SERVICE_UUID])
    {
        for (CBCharacteristic *aChar in [[CBManager sharedManager] myService].characteristics)
        {
            if ([aChar.UUID isEqual:THM_TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID]){
                
                if (aChar.isNotifying)
                {
                    [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO  forCharacteristic:aChar];
                    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:THM_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:THM_TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID] descriptor:nil operation:STOP_INDICATE];
                }
                cbCharacteristicDiscoverHandler(YES,nil);
            }
        }

    }
}


#pragma mark - CBCharecteristicManger

/*!
 *  @method peripheral: didDiscoverCharacteristicsForService: error:
 *
 *  @discussion Method invoked when characteristics are discovered for a service
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:THM_SERVICE_UUID]){
        for (CBCharacteristic *aChar in service.characteristics){
            if ([aChar.UUID isEqual:THM_TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID]){
                
                [[[CBManager sharedManager] myPeripheral] setNotifyValue:YES forCharacteristic:aChar];
                
                [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:THM_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:THM_TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID] descriptor:nil operation:START_INDICATE];
                
                cbCharacteristicDiscoverHandler(YES,nil);
            }
            else if([aChar.UUID isEqual:THM_TEMPERATURE_TYPE_CHARACTERISTIC_UUID])
            {
                [[[CBManager sharedManager] myPeripheral] readValueForCharacteristic:aChar];
                
                [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:THM_SERVICE_UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:THM_TEMPERATURE_TYPE_CHARACTERISTIC_UUID] descriptor:nil operation:READ_REQUEST];
            }
        }
    }
    else
    {
        cbCharacteristicDiscoverHandler(NO,nil);
    }
    
}

/*!
 *  @method peripheral: didUpdateValueForCharacteristic: error:
 *
 *  @discussion Method invoked when the characteristic value changes
 *
 */

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error == nil)
    {
        if ([characteristic.UUID isEqual:THM_TEMPERATURE_MEASUREMENT_CHARACTERISTIC_UUID] && characteristic.value)
        {
            [self getTHMtemp:characteristic];
        }
        else if ([characteristic.UUID isEqual:THM_TEMPERATURE_TYPE_CHARACTERISTIC_UUID] && characteristic.value)
        {
            [self getTempType:characteristic];
        }
        
        cbCharacteristicHandler(YES,nil);
        
    }
    else
    {
        cbCharacteristicHandler(NO,error);
    }
    
}

/*!
 *  @method getTHMtemp:
 *
 *  @discussion   Instance method to get the temperature value
 *
 */


-(void)getTHMtemp:(CBCharacteristic *)characteristic
{
  
    // Convert the contents of the characteristic value to a data-object //
    NSData *data = [characteristic value];
    
    // Get the byte sequence of the data-object //
    const uint8_t *reportData = [data bytes];
    
    // Initialise the offset variable //
    NSUInteger offset = 1;
    // Initialise the bpm variable //
   
    if ((reportData[0] & 0x01) == 0) {
        
        [self calculateTemperaturefromCharacteristic:characteristic];

        offset = offset + 4; // Plus 4 byte //
        self.mesurementType = @"°C";
    }
    else {
        
        [self calculateTemperaturefromCharacteristic:characteristic];

        offset =  offset + 4; // Plus 4 bytes //
        self.mesurementType = @"°F";
    }
    
    
    /* timestamp */
    if( (reportData[0] & 0x02) )
    {
        uint16_t year = CFSwapInt16LittleToHost(*(uint16_t*)offset); offset += 2;
        uint8_t month = *(uint8_t*)offset; offset++;
        uint8_t day = *(uint8_t*)offset; offset++;
        uint8_t hour = *(uint8_t*)offset; offset++;
        uint8_t min = *(uint8_t*)offset; offset++;
        uint8_t sec = *(uint8_t*)offset; offset++;
        
        NSString * dateString = [NSString stringWithFormat:@"%d %d %d %d %d %d", year, month, day, hour, min, sec];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"yyyy MM dd HH mm ss"];
        NSDate* date = [dateFormat dateFromString:dateString];
        
        [dateFormat setDateFormat:@"EEE MMM dd, yyyy"];
        NSString* dateFormattedString = [dateFormat stringFromDate:date];
        
        [dateFormat setDateFormat:@"h:mm a"];
        NSString* timeFormattedString = [dateFormat stringFromDate:date];
        
        
        if( dateFormattedString && timeFormattedString )
        {
            self.timeStampString = [NSString stringWithFormat:@"%@ at %@", dateFormattedString, timeFormattedString];
        }
    }
    
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",NOTIFY_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:data]]];
}

/*!
 *  @method calculateTemperaturefromCharacteristic
 *
 *  @discussion Method to calculate the temperature
 *
 */


-(void) calculateTemperaturefromCharacteristic:(CBCharacteristic *)characteristic
{
    // Convert the contents of the characteristic value to a data-object //
    NSData *data = [characteristic value];
    
    // Get the byte sequence of the data-object //
    const uint8_t *reportData = [data bytes];
    
    unsigned char *commandPacket =  (unsigned char *)malloc(4 * sizeof(unsigned char));
    
    reportData++;
    int32_t tempData ;
    
    if (reportData[2] != 0xff)
    {
        commandPacket[0] = reportData[0];
        commandPacket[1] = reportData[1];
        commandPacket[2] = reportData[2];
        commandPacket[3] = 0x00;
    }
    else
    {
        commandPacket[0] = ~ (reportData[0] - 1);
        commandPacket[1] = ~reportData[1];
        commandPacket[2] = ~reportData[2];
        commandPacket[3] = 0x00;
    }
    
    NSData *testData = [NSData dataWithBytes:commandPacket length:4];
    const uint8_t *re = [testData bytes];
    tempData = (int32_t)CFSwapInt32LittleToHost(*(uint32_t*)re);

    int8_t exponent = (int8_t)(tempData >> 24);
    int32_t mantissa = (int32_t)(tempData & 0x00FFFFFF);
    
    if( tempData == 0x007FFFFF )
    {
        NSLog(@"Invalid temperature value received");
        return;
    }
    
    float tempValue = (float)(mantissa*pow(10, exponent));
    
    if (reportData[2] == 0xff)
    {
        tempValue = tempValue * -1;
    }
    self.tempStringValue = [NSString stringWithFormat:@"%.1f",(float) tempValue];
    free(commandPacket);

}

/*!
 *  @method isTempTypeValid:
 *
 *  @discussion   Instance method to check temperature type exist or not
 *
 */

-(BOOL)isTempTypeValid:(CBCharacteristic *)characteristic
{
    NSData * updatedValue = characteristic.value;
    uint8_t* dataPointer = (uint8_t*)[updatedValue bytes];
    
    uint8_t flags = dataPointer[0];
    
     if( flags & 0x04 )
     {
         return true;
     }
    return false;
}

/*!
 *  @method getTempType:
 *
 *  @discussion   Instance method to get the Temperature Type characteristic is an enumeration that indicates where the temperature was measured
 *
 */

-(void)getTempType:(CBCharacteristic *)characteristic
{
    /* temperature type */
    
    NSData * updatedValue = characteristic.value;
    uint8_t* dataPointer = (uint8_t*)[updatedValue bytes];
    uint8_t type = *(uint8_t*)dataPointer;
    NSString* location = nil;
    
    switch (type)
    {
        case 0x01:
            location = @"Armpit";
            break;
        case 0x02:
            location = @"Body (general)";
            break;
        case 0x03:
            location = @"Ear";
            break;
        case 0x04:
            location = @"Finger";
            break;
        case 0x05:
            location = @"Gastro-intenstinal Tract";
            break;
        case 0x06:
            location = @"Mouth";
            break;
        case 0x07:
            location = @"Rectum";
            break;
        case 0x08:
            location = @"Toe";
            break;
        case 0x09:
            location = @"Tympanum - ear drum";
            break;
        default:
            break;
    }
    if (location)
    {
        self.tempType = [NSString stringWithFormat:@"%@", location];
    }
    
    [Utilities logDataWithService:[ResourceHandler getServiceNameForUUID:characteristic.service.UUID] characteristic:[ResourceHandler getCharacteristicNameForUUID:characteristic.UUID] descriptor:nil operation:[NSString stringWithFormat:@"%@%@ %@",READ_RESPONSE,DATA_SEPERATOR,[Utilities convertDataToLoggerFormat:updatedValue]]];
}




@end
