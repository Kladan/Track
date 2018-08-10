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
#include "PAL_initialize_ih.h"
#include "PAL_socketMonitor_ih.h"

// MQTT
#include "Serval_Mqtt.h"

//
#include "XdkSensorHandle.h"


/* constant definitions ***************************************************** */
#define TIMERBLOCKTIME UINT32_C(0xffff)
#define TIMER_AUTORELOAD_ON pdTRUE
#define TIMER_AUTORELOAD_OFF pdFALSE
#define HOURS(x) ((portTickType) (x * 3600000) / portTICK_RATE_MS)
#define SECONDS(x) ((portTickType) (x * 1000) / portTICK_RATE_MS)
#define MILLISECONDS(x) ((portTickType) x / portTICK_RATE_MS)

//#define MQTT_BROKER_HOST "broker.hivemq.com"
#define MQTT_BROKER_HOST "192.168.33.25"
#define MQTT_BROKER_PORT 1883

/* local variables ********************************************************** */
static MqttSession_T session;
static MqttSession_T *session_ptr = &session;
WlanConnect_SSID_T connectSSID = (WlanConnect_SSID_T)"EventiLoccioni";
WlanConnect_PassPhrase_T connectPassPhrase = (WlanConnect_PassPhrase_T)"welcometoloccioni";
xTimerHandle timerHandle;
char * outputMqtt;

int32_t getTemperature = INT32_C(0);
uint32_t getHumidity = INT32_C(0);
uint32_t getPressure = INT32_C(0);

/* global variables ********************************************************* */

/* inline functions ********************************************************* */

/* local functions ********************************************************** */

/* global functions ********************************************************* */

/**
 * @brief This is a template function where the user can write his custom application.
 *
 */
void initDeviceId(void) {
	xdkID = (char*) malloc(16);
    unsigned int * serialStackAddress0 = 0xFE081F0;
    unsigned int * serialStackAddress1 = 0xFE081F4;

    unsigned int serialUnique0 = *serialStackAddress0;
    unsigned int serialUnique1 = *serialStackAddress1;
    sprintf(xdkID, "0x%08x%08x",serialUnique1,serialUnique0);

    outputMqtt = (char*) malloc(50*sizeof(char));
}

void initGPIO(void) {
	GPIO_PinModeSet(gpioPortD, 5, gpioModeInputPull, 0);
	GPIO_PinOutClear(gpioPortD, 5);

	ADC_InitSingle_TypeDef channelInit = ADC_INITSINGLE_DEFAULT;
	channelInit.reference = adcRef2V5;
	channelInit.resolution = adcRes12Bit;
	channelInit.input = adcSingleInpCh5;
	ADC_InitSingle(ADC0, &channelInit);
}

uint32_t getSoilData(void) {
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

void printOwnIp(void) {
	NetworkConfig_IpSettings_T myIp;
	NetworkConfig_GetIpSettings(&myIp);

	// insert a delay here, if the IP is not properly printed
	printf("The IP was retrieved: %u.%u.%u.%u \n\r",
	(unsigned int) (NetworkConfig_Ipv4Byte(myIp.ipV4, 3)),
	(unsigned int) (NetworkConfig_Ipv4Byte(myIp.ipV4, 2)),
	(unsigned int) (NetworkConfig_Ipv4Byte(myIp.ipV4, 1)),
	(unsigned int) (NetworkConfig_Ipv4Byte(myIp.ipV4, 0)));
}

void connectToWifi(void) {
	Retcode_T retStatusConnect = (Retcode_T) WlanConnect_WPA(connectSSID,
	            connectPassPhrase,0);
	if (retStatusConnect == RETCODE_OK) {
		printOwnIp();
	}
}

static void publish(void) {
	if (WlanConnect_GetCurrentNwStatus() != CONNECTED_AND_IPV4_ACQUIRED){
		connectToWifi();
	}
	static char *pub_topic = "SensorData";
	static StringDescr_T pub_topic_descr;
	StringDescr_wrap(&pub_topic_descr, pub_topic);

	Mqtt_publish(session_ptr, pub_topic_descr, outputMqtt,
                strlen(outputMqtt), MQTT_QOS_AT_MOST_ONE, false);
}

void printData(xTimerHandle xTimer) {
	(void) xTimer;

	Environmental_readHumidity(xdkEnvironmental_BME280_Handle,&getHumidity);
	Environmental_readTemperature(xdkEnvironmental_BME280_Handle,&getTemperature);
	Environmental_readPressure(xdkEnvironmental_BME280_Handle,&getPressure);

	sprintf(outputMqtt, "{\
			\"deviceIdentifier\": \"%s\",\
			\"soilHumidity\": %lu,\
			\"temperature\": %ld,\
			\"environmentHumidity\": %lu,\
			\"pressure\": %lu}", \
			xdkID,(unsigned long)getSoilData(), (long) (getTemperature-6)/1000, (unsigned long) getHumidity, (unsigned long) getPressure);
	publish();
	// printf("Messweert: Test\n\r");
}

void createTimer(void) {
	timerHandle = xTimerCreate(
		(const char * const) "My Timer", // used only for debugging purposes
		SECONDS(3),                     // timer period
		TIMER_AUTORELOAD_ON,             // Autoreload on or off - should the timer
                                     // start again after it expired?
		NULL,                            // optional identifier
		printData                  // static callback function
	);
	if(NULL == timerHandle) {
		assert(pdFAIL);
		return;
	}
}



void initWifi(void) {
	WlanConnect_Init();
	NetworkConfig_SetIpDhcp(0);
	connectToWifi();

	PAL_initialize();
	PAL_socketMonitorInit();
}

static void handle_connection(MqttConnectionEstablishedEvent_T connectionData) {
	int rc_connect = (int) connectionData.connectReturnCode;
	printf("Connection Event:\n\r"
          "\tServer Return Code: %d (0 for success)\n\r",
          (int) rc_connect);
}

retcode_t connectMQTT(void) {
	retcode_t rc = RC_INVALID_STATUS;
	rc = Mqtt_connect(session_ptr);
	if (rc != RC_OK) {
		printf("Could not connect, error 0x%04x\n", rc);
	}
	return rc;
}

retcode_t event_handler(MqttSession_T* session, MqttEvent_t event,
              const MqttEventData_t* eventData) {
	BCDS_UNUSED(session);
	switch(event){
    	case MQTT_CONNECTION_ESTABLISHED:
    		handle_connection(eventData->connect);
    		// subscribing and publishing can now be done
    		BaseType_t timerResult = xTimerStart(timerHandle, TIMERBLOCKTIME);
    		if(pdTRUE != timerResult) {
    			assert(pdFAIL);
    		}
    		// publish();
    		break;
    	case MQTT_CONNECTION_ERROR:
    		handle_connection(eventData->connect);
    		connectMQTT();
    		break;
    	case MQTT_INCOMING_PUBLISH:
    		break;
    	case MQTT_SUBSCRIPTION_ACKNOWLEDGED:
    		printf("Subscription Successful\n\r");
			break;
    	case MQTT_PUBLISHED_DATA:
    		printf("Publish Successful\n\r");
    		break;
    	default:
    		printf("Unhandled MQTT Event: %d\n\r", event);
    		break;
	}
	return RC_OK;
}

retcode_t initMQTT(void) {
	retcode_t rc_initialize = Mqtt_initialize();
	if (rc_initialize == RC_OK) {
		session_ptr = &session;
		Mqtt_initializeInternalSession(session_ptr);
	}
	return rc_initialize;
}


void config_set_target(void) {
	static char mqtt_broker[64];
	const char *mqtt_broker_format = "mqtt://%s:%d";
	char server_ip_buffer[13];
	Ip_Address_T ip;

	PAL_getIpaddress((uint8_t *) MQTT_BROKER_HOST, &ip);
	Ip_convertAddrToString(&ip, server_ip_buffer);
	sprintf(mqtt_broker, mqtt_broker_format,
		  server_ip_buffer, MQTT_BROKER_PORT);

	printf(mqtt_broker);
	SupportedUrl_fromString(mqtt_broker,
              (uint16_t) strlen(mqtt_broker), &session_ptr->target);
}

void config_set_connect_data(void) {
	char *device_name = xdkID;
	static char *username = "xdk";
	static char *password = "xdk";

	session_ptr->MQTTVersion = 3;
	session_ptr->keepAliveInterval = 100;
	session_ptr->cleanSession = true;
	session_ptr->will.haveWill = false;


	StringDescr_T device_name_descr;
	StringDescr_wrap(&device_name_descr, device_name);
	session_ptr->clientID = device_name_descr;

	StringDescr_T username_descr;
	StringDescr_wrap(&username_descr, username);
	session_ptr->username = username_descr;

	StringDescr_T password_descr;
	StringDescr_wrap(&password_descr, password);
	session_ptr->password = password_descr;
}

void config_set_event_handler(void) {
	session_ptr->onMqttEvent = event_handler;
}

void appInitSystem(void * CmdProcessorHandle, uint32_t param2) {

    if (CmdProcessorHandle == NULL)
    {
        printf("Command processor handle is null \n\r");
        assert(false);
    }
    BCDS_UNUSED(param2);
    Board_EnablePowerSupply3V3(EXTENSION_BOARD);

    initDeviceId();
    initGPIO();
    Environmental_init(xdkEnvironmental_BME280_Handle);
    createTimer();
    initWifi();

    retcode_t rc = RC_MQTT_NOT_CONNECTED;
    rc = initMQTT();
    if(rc == RC_OK){
    	config_set_target();
    	config_set_connect_data();
    	config_set_event_handler();
    	connectMQTT();
    } else {
    	printf("Initialize Failed\n\r");
    }
}
/**@} */
/** ************************************************************************* */
