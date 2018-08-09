/*
* Licensee agrees that the example code provided to Licensee has been developed and released by Bosch solely as an example to be used as a potential reference for Licensee�s application development. 
* Fitness and suitability of the example code for any use within Licensee�s applications need to be verified by Licensee on its own authority by taking appropriate state of the art actions and measures (e.g. by means of quality assurance measures).
* Licensee shall be responsible for conducting the development of its applications as well as integration of parts of the example code into such applications, taking into account the state of the art of technology and any statutory regulations and provisions applicable for such applications. Compliance with the functional system requirements and testing there of (including validation of information/data security aspects and functional safety) and release shall be solely incumbent upon Licensee. 
* For the avoidance of doubt, Licensee shall be responsible and fully liable for the applications and any distribution of such applications into the market.
* 
* 
* Redistribution and use in source and binary forms, with or without 
* modification, are permitted provided that the following conditions are 
* met:
* 
*     (1) Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer. 
* 
*     (2) Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in
*     the documentation and/or other materials provided with the
*     distribution.  
*     
*     (3)The name of the author may not be used to
*     endorse or promote products derived from this software without
*     specific prior written permission.
* 
*  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR 
*  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
*  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
*  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
*  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
*  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
*  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
*  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
*  POSSIBILITY OF SUCH DAMAGE.
*/
/*----------------------------------------------------------------------------*/
/**
* @ingroup APPS_LIST
*
* @defgroup XDK_APPLICATION_TEMPLATE XDK Application Template
* @{
*
* @brief XDK Application Template
*
* @details Empty XDK Application Template without any functionality. Should be used as a template to start new projects.
*
* @file
**/
/* module includes ********************************************************** */

/* system header files */
#include <stdio.h>
/* additional interface header files */
#include "FreeRTOS.h"
#include "timers.h"

/* own header files */
#include "XdkApplicationTemplate.h"
#include "BCDS_CmdProcessor.h"
#include "BCDS_Assert.h"
// auslesehen ID
#include "em_usb.h"

// ADC wandler
#include "em_adc.h"
#include "em_gpio.h"
#include "BSP_BoardShared.h"

// WLan
#include "BCDS_WlanConnect.h"
#include "BCDS_NetworkConfig.h"

/* constant definitions ***************************************************** */
#define TIMERBLOCKTIME UINT32_C(0xffff)
#define TIMER_AUTORELOAD_ON pdTRUE
#define TIMER_AUTORELOAD_OFF pdFALSE
#define SECONDS(x) ((portTickType) (x * 1000) / portTICK_RATE_MS)
#define MILLISECONDS(x) ((portTickType) x / portTICK_RATE_MS)
/* local variables ********************************************************** */
WlanConnect_SSID_T connectSSID = "EventiLoccioni";
WlanConnect_PassPhrase_T connectPassPhrase = "welcometoloccioni";
/* global variables ********************************************************* */

/* inline functions ********************************************************* */

/* local functions ********************************************************** */

/* global functions ********************************************************* */

/**
 * @brief This is a template function where the user can write his custom application.
 *
 */
void initDeviceId(void){
	xdkID = (char*) malloc(8);
    unsigned int * serialStackAddress0 = 0xFE081F0;
    unsigned int * serialStackAddress1 = 0xFE081F4;

    unsigned int serialUnique0 = *serialStackAddress0;
    unsigned int serialUnique1 = *serialStackAddress1;
    sprintf(xdkID, "0x%08x%08x\n\r",serialUnique1,serialUnique0);
}

void initGPIO(void){
	GPIO_PinModeSet(gpioPortD, 5, gpioModeInputPull, 0);
	GPIO_PinOutClear(gpioPortD, 5);

	ADC_InitSingle_TypeDef channelInit = ADC_INITSINGLE_DEFAULT;
	channelInit.reference = adcRef2V5;
	channelInit.resolution = adcRes12Bit;
	channelInit.input = adcSingleInpCh5;
	ADC_InitSingle(ADC0, &channelInit);
}

uint32_t getData(void){
	uint32_t AdcSample = 0;
	while ((ADC0->STATUS & (ADC_STATUS_SINGLEACT)) && (BSP_UNLOCKED == ADCLock));
	__disable_irq();
	ADCLock = BSP_LOCKED;
	__enable_irq();
	ADC_Start(ADC0, adcStartSingle);
	// Wait while conversion is active
	while (ADC0->STATUS & (ADC_STATUS_SINGLEACT));
	AdcSample = 0xFFF & ADC_DataSingleGet(ADC0);
	__disable_irq();
	ADCLock = BSP_UNLOCKED;
	__enable_irq();
	return AdcSample;
}

void printData(xTimerHandle xTimer){
	(void) xTimer;
	printf("Messwert: %lu\n\r", (unsigned long)getData());
	// printf("Messweert: Test\n\r");
}

void createAndStartTimer(TimerCallbackFunction_t callback)
{
  xTimerHandle timerHandle = xTimerCreate(
    (const char * const) "My Timer", // used only for debugging purposes
    SECONDS(3),                     // timer period
    TIMER_AUTORELOAD_ON,             // Autoreload on or off - should the timer
                                     // start again after it expired?
    NULL,                            // optional identifier
	callback                  // static callback function
  );
  if(NULL == timerHandle) {
    assert(pdFAIL);
    return;
  }
  BaseType_t timerResult = xTimerStart(timerHandle, TIMERBLOCKTIME);
  if(pdTRUE != timerResult) {
    assert(pdFAIL);
  }
}

void initWifi(void){
	WlanConnect_Init();
	Retcode_T retStatusConnect = (Retcode_T) WlanConnect_WPA(connectSSID,
	            connectPassPhrase,0);
	if (retStatusConnect == RETCODE_OK) {
	  printf("Connected successfully.\n\r");
	}
}

void appInitSystem(void * CmdProcessorHandle, uint32_t param2)
{

    if (CmdProcessorHandle == NULL)
    {
        printf("Command processor handle is null \n\r");
        assert(false);
    }
    BCDS_UNUSED(param2);
    initDeviceId();
    initGPIO();
    createAndStartTimer(printData);
    initWifi();
}
/**@} */
/** ************************************************************************* */
