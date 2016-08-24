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

#import <Foundation/Foundation.h>

@interface RSCModel : NSObject

/*!
 *  @property InstantaneousSpeed
 *
 *  @discussion Speed at a particular moment, Unit is in m/s with a resolution of 1/256 s.
    Converted to km/hr  ( m/s *3.6)
 *
 */
@property(nonatomic ,assign )float InstantaneousSpeed;

/*!
 *  @property InstantaneousCadence
 *
 *  @discussion  Unit is in 1/minute (or RPM) with a resolutions of 1 1/min (or 1 RPM)
 *
 */
@property(nonatomic ,assign )float InstantaneousCadence;

/*!
 *  @property InstantaneousStrideLength
 *
 *  @discussion   Unit is in meter with a resolution of 1/100 m (or centimeter).
 *
 */
@property(nonatomic ,assign )float InstantaneousStrideLength;

/*!
 *  @property TotalDistance
 *
 *  @discussion   Unit is in meter with a resolution of 1/10 m (or decimeter).
 *
 */
@property(nonatomic ,assign )float TotalDistance;

/*!
 *  @property IsWalking
 *
 *  @discussion   Walking or Running Status .
 *
 */
@property(nonatomic ,assign )BOOL  IsWalking;

-(void)startDiscoverChar:(void (^) (BOOL success, NSError *error))handler;
-(void)updateCharacteristicWithHandler:(void (^) (BOOL success, NSError *error))handler;
-(void)stopUpdate;

@end
