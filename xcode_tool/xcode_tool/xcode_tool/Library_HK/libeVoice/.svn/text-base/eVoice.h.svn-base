/*=========================================================================*/

/**
 
 * \file	eVoice.h
 
 * 
 
 * \version	2.1.0
 
 * 
 
 * \brief	Declaration of eVoice APIs
 
 */

/*=========================================================================*/

#ifndef EVOICE_H

#define EVOICE_H





/** rief	definition of encoding type*/

#define ENCODING_AUTO		0

#define ENCODING_GB 		1

#define ENCODING_GBK 		2

#define ENCODING_BIG5		3



/** \brief	definition of language mode*/

#define MANDARIN			0
#define CANTONESE			1
#define ENGLISH				2
#define MAND_ENG			3
#define CANT_ENG			4


/** \brief	definition of synthesis mode*/

#define TTS_SYN_WHOLE		0				    ///<  synthesize the whole input text at one time
#define TTS_SYN_SENTENCE	1					///<  synthesize the first sentence of input text at one time


/** \brief	definition of TTS engine status*/

#define TTS_STATUS_UNINITIAL			0    	///<  TTS status is unintialed
#define TTS_STATUS_INVALIDATEHANDLE		1		///<  TTS status is that handle is invalidated
#define TTS_STATUS_IDLE					2		///<  TTS status is idle
#define TTS_STATUS_SYNTHESIS			3		///<  TTS status is synthesising


/** \brief	definition of special effect*/

#define SPECIAL_EFFECT_NONE		0
#define SPECIAL_EFFECT_CHILD	1
#define SPECIAL_EFFECT_DEEP		2
#define SPECIAL_EFFECT_MACHINE	3
#define SPECIAL_EFFECT_HOARSE	4




#ifdef __cplusplus

extern "C" {
    
#endif
    
    
    
    
    
    /*------------------------------tts* group---------------------------------*/
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Initialize tts system.
     配置参数位于eVoice.ini中，需要先读取该文件并解析参数
     * \param	szIniFileName		<in>	full file name of eVoice.ini
     * \return	tts handle if success, -1 if software is expired, 0 if directory is null or wrong
     */
    /*-------------------------------------------------------------------------*/
    int ttsInitial(char *szIniFileName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		close the tts system.
     * \param	nTTSHandle		<in>	tts handle, which is the return of function ttsInitial();
     * \return	1: close sccessfully, 0: handle is NULL
     */
    /*-------------------------------------------------------------------------*/
    int ttsClose(int nTTSHandle);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Initialize the tts resource.
     配置参数位于eVoice.ini中，需要先读取该文件并解析参数
     * \param	szIniFileName		<in>	full file name of eVoice.ini
     * \return	the handle of TTS resource if success, -1 if software is expired, 0 if fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsInitialResource(char *szIniFileName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		release the tts resource.
     * \param	nResourceHandle		[in]	handle of tts resource to be released, which is the return of ttsInitialResource()
     * \return	1: close sccessfully, 0: handle is NULL
     */
    /*-------------------------------------------------------------------------*/
    int ttsCloseResource(int nResourceHandle);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Stop the specified TTS engine.
     * \param	nTTSHandle		[in]	handle of TTS to be stopped
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsStop(int nTTSHandle);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Query status of a specified TTS engine
     * \param	nTTSHandle		[in]	handle of specified TTS engine
     * \return	the status of tts if successful, otherwise TTS_STATUS_INVALIDATEHANDLE
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetStatus(int nTTSHandle);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Synthsis the given text. At the same time output the description of the internal information
     * \param	nTTSHandle	[in]	handle of TTS
     * \param	szText		[in]	the text to be synthesised
     * \param	pnWave		[out]	the synthesised wave datas 
     * \param	nCodeType	<in>	1-GB,  2-GBK traditional,  3-BIG5, others-程序自动判断
     * \param	pnLength	[out]	the length of synthesised wave datas 
     * \param	szTrans		[out]	the description of the internal information  
     * \return	0: failure, 1: success and TTS_SYN_WHOLE is set, others: the index of next sentence when  TTS_SYN_SENTENCE is set
     */
    /*-------------------------------------------------------------------------*/
    char* ttsSynthesisDebug(int nTTSHandle, char *szText,int nCodeType, short *pnWave, int *pnLength, char *szTrans);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Synthsis the given text.
     * \param	nTTSHandle	[in]	handle of TTS
     * \param	szText		[in]	the text to be synthesised
     * \param	nCodeType	[in]	1-GB,  2-GBK traditional,  3-BIG5, others-程序自动判断
     * \param	pnWave		[out]	the synthesised wave datas 
     * \param	pnLength	[out]	the length of synthesised wave datas 
     * \return	0: failure, 	others	the pointer of next sentence, 
     */
    /*-------------------------------------------------------------------------*/
    char* ttsSynthesis(int nTTSHandle, char *szText,int nCodeType, short *pnWave, int *pnLength, void *SynCallBack);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Get the utterance of the specified TTS engine
     * \param	nTTSHandle		[in]	handle of TTS 
     * \return	the pointer of utterance if successful, otherwise 0
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetUtterance(int nTTSHandle);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set language mode.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	fSpeed		[in]	the rate of playing speed, 1.0 is the default speed
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetLangMode(int nTTSHandle,int nLangMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get language mode..
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pnLangMode	[in]	pointer of language mode 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetLangMode(int nTTSHandle,int *pnLangMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the audio library list of specified language.
     * \param	nTTSHandle		[in]	handle of TTS 
     * \param	nLanguage		[in]	language specified
     * \param	pszAudLibList	[out]	audio library list
     * \return	0: fault, others: number of audio libraries
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetAudLibList(int nTTSHandle,int nLanguage,char **pszAudLibList);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the audio library description list of specified language.
     * \param	nTTSHandle			[in]	handle of TTS 
     * \param	nLanguage			[in]	language specified
     * \param	pszAudLibDescList	[out]	audio library description list
     * \return	0: fault, others: number of audio libraries
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetAudLibDescList(int nTTSHandle,int nLanguage,char **pszAudLibDescList);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Set the playing speed of the specified TTS engine. It's a relative value, 1 is default speed.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	fSpeed		[in]	the rate of playing speed, 1.0 is the default speed
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetSpeed(int nTTSHandle,float fSpeed);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Get the playing speed of the specified TTS engine. It's a relative value, 1 is default speed.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pfSpeed		[out]	pointer of speed 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetSpeed(int nTTSHandle,float *pfSpeed);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set the adjusting ratio of pitch. It's a relative value, 1 is default speed.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	fPitchRatio	[in]	the adjusting ratio of pitch
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetPitchRatio(int nTTSHandle,float fPitchRatio);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the adjusting ratio of pitch.. It's a relative value, 1 is default speed.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pfPitchRatio[in]	pointer of the adjusting ratio of pitch
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetPitchRatio(int nTTSHandle,float* pfPitchRatio);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set adjusting ratio of volume.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	fVolume		[in]	volume, 1.0 is the default volume
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetVolume(int nTTSHandle,float fVolume);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the volume.
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pfVolume	[out]	pointer of volume 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetVolume(int nTTSHandle,float *pfVolume);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set active audio library of specified language, 
     * \param	nTTSHandle		[in]	handle of TTS 
     * \param	nLanguage		[in]	specified language
     * \param	szAudLibName	[in]	name of audio lib to be loaded
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetAudLib(int nTTSHandle, int nLanguage, char *szAudLibName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the name of active audio library of specified language
     * \param	nTTSHandle		[in]	handle of TTS 
     * \param	nLanguage		[in]	specified language
     * \param	szAudLibName	[in]	name of audio lib to be loaded
     * \return	1: success, 	0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetAudLib(int nTTSHandle,int nLanguage, char *szAudLibName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	set whether to set 'return' as end symbol of sentences
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	cSet			[in]	 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetRdReturn(int nTTSHandle, char cSet);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	check whether setting 'return' as end symbol of sentences
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pcSet		[out]	
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetRdReturn(int nTTSHandle, char *pcSet);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set the TTS engine to read out symbol,which is ignored in default
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	cRdSymbol	[in]	the flag whether read out symbols
     * \return	1: success, 0: fault	
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetReadPunc(int nTTSHandle, char cRdSymbol);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	check whether TTS engin is to read out symbol
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pcRdSymbol	[out]	the flag whether read out symbols
     * \return	1: success, 0: fault	
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetReadPunc(int nTTSHandle, char *pcRdSymbol);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Set the operation mode of TTS synthesis, single sentence or hole paragraph
     * \param	nTTSHandle		[in]	handle of TTS 
     * \param	cSentenceMode	[in]	sentence mode , which should only be TTS_SYN_WHOLE or TTS_SYN_SENTENCE
     * \return	1: success, 	0: fault	
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetSentenceMode(int nTTSHandle, char cSentenceMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Get the operation mode of TTS synthesis, single sentence or hole paragraph
     * \param	nTTSHandle		[in]	handle of TTS 
     * \param	pcSentenceMode	[out]	pointer ofsentence mode , which should only be TTS_SYN_WHOLE or TTS_SYN_SENTENCE
     * \return	1: success, 	0: pointer is NULL	
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetSentenceMode(int nTTSHandle, char *pcSentenceMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Get the approximate buffer size which is big enough to stroing the synthesized wave data
     * \param	nTTSHandle		[in]	handle of TTS 
     * \param	szText			[in]	the text to be synthesized
     * \param	nCodeType		[in]	1-GB,  2-GBK traditional,  3-BIG5, others-程序自动判断
     * \return	0: pointer is NULL,  others: the approximate buffer size	
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetApproxBufSize(int nTTSHandle,char *szText,int nCodeType);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Convert the input text to pinying sequence
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	szText		[in]	input text
     * \param	nEncodeType	[in]	1-GB,  2-GBK traditional,  3-BIG5, others-程序自动判断
     * \param	szPinyin	[out]	output pinyin sequence
     * \return	1: success, 	0: pointer is NULL	
     */
    /*-------------------------------------------------------------------------*/
    int ttsTextToPinyin(int nTTSHandle, char *szText,int nEncodeType,char *szPinyin);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set special effect..
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	nEffectIdx	[in]	index of special effect
     0	SPECIAL_EFFECT_NONE	
     1	SPECIAL_EFFECT_CHILD
     2	SPECIAL_EFFECT_DEEP	
     3	SPECIAL_EFFECT_MACHINE
     4	SPECIAL_EFFECT_HOARSE	
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsSetSpecialEff(int nTTSHandle, int nEffectIdx);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get index of special effect
     * \param	nTTSHandle	[in]	handle of TTS 
     * \param	pnEffectIdx	[in]	pointer of index of special effect
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int ttsGetSpecialEff(int nTTSHandle, int* pnEffectIdx);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /*				The following functions are for internal use			   */
    
    
    
    
    /*------------------------------stts* group--------------------------------*/
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Initialize tts with audio function
     * \param	szIniFileName	[in]	full file name of eVoice.ini
     * \return	0				directory is null or wrong
     * \return	-1				wiston system software is expired
     * \return	others			the handle of TTS
     */
    /*-------------------------------------------------------------------------*/
    int sttsInitial(char *szIniFileName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Close tts with audio function
     * \param	none
     * \return	0: failed		1: success
     */
    /*-------------------------------------------------------------------------*/
    int sttsClose();
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Query status of TTS engine
     * \param	none
     * \return	status of TTS
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetStatus();
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Run TTS play engine to synthesis text to audio and play the audio
     * \param	hWnd	[in]	handle of current window
     * \param	szText	[in]	the text needs to be synthesised
     * \param	nCodeType	[in]	1-GB,  2-GBK traditional,  3-BIG5, others-程序自动判断
     * \return	0: failed			1: success
     */
    /*-------------------------------------------------------------------------*/
    int sttsPlay(int hWnd, char *szText,int nCodeType);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		pause the playing of speech
     * \param	none
     * \return	0: tts handle is invalid	 	1: success
     */
    /*-------------------------------------------------------------------------*/
    int sttsPause();
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		resume the playing of speech
     * \param	none
     * \return	0: tts handle is invalid	 	1: success
     */
    /*-------------------------------------------------------------------------*/
    int sttsResume();
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set language mode.
     * \param	fSpeed		[in]	the rate of playing speed, 1.0 is the default speed
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetLangMode(int nLangMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get language mode..
     * \param	pnLangMode	[in]	pointer of language mode 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetLangMode(int *pnLangMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the audio library list of specified language.
     * \param	nLanguage		[in]	language specified
     * \param	pszAudLibList	[in]	audio library list
     * \return	0: fault, others: number of audio libraries
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetAudLibList(int nLanguage,char **pszAudLibList);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the audio library description list of specified language.
     * \param	nLanguage			[in]	language specified
     * \param	pszAudLibDescList	[out]	audio library description list
     * \return	0: fault, others: number of audio libraries
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetAudLibDescList(int nLanguage,char **pszAudLibDescList);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set active audio library of specified language, 
     * \param	nLanguage		[in]	specified language
     * \param	szAudLibName	[in]	name of audio lib to be loaded
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetAudLib(int nLanguage, char *szAudLibName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the name of active audio library of specified language
     * \param	nLanguage		[in]	specified language
     * \param	szAudLibName	[in]	name of audio lib to be loaded
     * \return	1: success, 	0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetAudLib(int nLanguage, char *szAudLibName);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Set the playing speed of the specified TTS engine. It's a relative value, 1 is default speed.
     * \param	fSpeed		[in]	the rate of playing speed, 1.0 is the default speed
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetSpeed(float fSpeed);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Get the playing speed of the specified TTS engine. It's a relative value, 1 is default speed.
     * \param	pfSpeed		[out]	pointer of speed 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetSpeed(float *pfSpeed);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Stop the synthesizing
     * \param	none
     * \return	0: tts handle is invalid	 	1: success
     */
    /*-------------------------------------------------------------------------*/
    int sttsStop();
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set the adjusting ratio of pitch. It's a relative value, 1 is default speed.
     * \param	fPitchRatio	[in]	the adjusting ratio of pitch
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetPitchRatio(float fPitchRatio);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the adjusting ratio of pitch.. It's a relative value, 1 is default speed.
     * \param	pfPitchRatio[in]	pointer of the adjusting ratio of pitch
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetPitchRatio(float* pfPitchRatio);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set the adjusting ratio of silence duration, 1 is default speed.
     * \param	fSilDurRatio[in]	the adjusting ratio of silence duration, 1.0 is the default speed
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetSilDurRatio(float fSilDurRatio);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the adjusting ratio of silence duration, 1 is default speed.
     * \param	pfSilDurRatio	[in]	pointer of speed adjusting ratio of silence duration
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetSilDurRatio(float *pfSilDurRatio);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set adjusting ratio of volume.
     * \param	fVolume		[in]	volume, 1.0 is the default volume
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetVolume(float fVolume);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the volume.
     * \param	pfVolume	[out]	pointer of volume 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetVolume(float *pfVolume);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	set whether to set 'return' as end symbol of sentences
     * \param	cSet			[in]	 
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetRdReturn(char cSet);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	check whether setting 'return' as end symbol of sentences
     * \param	pcSet		[out]	
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetRdReturn(char *pcSet);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set the TTS engine to read out symbol,which is ignored in default
     * \param	cRdSymbol	[in]	the flag whether read out symbols
     * \return	1: success, 0: fault	
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetReadPunc(char cRdSymbol);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	check whether TTS engin is to read out symbol
     * \param	pcRdSymbol	[out]	the flag whether read out symbols
     * \return	1: success, 0: fault	
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetReadPunc(char *pcRdSymbol);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set the operation mode of TTS synthesis, single sentence or hole paragraph
     * \param	cSentenceMode	[in]	sentence mode , which should only be TTS_SYN_WHOLE or TTS_SYN_SENTENCE
     * \return	1: success, 	0: fault	
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetSentenceMode(char cSentenceMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get the operation mode of TTS synthesis, single sentence or hole paragraph
     * \param	pcSentenceMode	[out]	pointer ofsentence mode , which should only be TTS_SYN_WHOLE or TTS_SYN_SENTENCE
     * \return	1: success, 	0: pointer is NULL	
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetSentenceMode(char *pcSentenceMode);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Set special effect..
     * \param	nEffectIdx	[in]	index of special effect
     0	SPECIAL_EFFECT_NONE	
     1	SPECIAL_EFFECT_CHILD
     2	SPECIAL_EFFECT_DEEP	
     3	SPECIAL_EFFECT_MACHINE
     4	SPECIAL_EFFECT_HOARSE	
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsSetSpecialEff(int nEffectIdx);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief	Get index of special effect
     * \param	pnEffectIdx	[in]	pointer of index of special effect
     * \return	1: success, 0: fault
     */
    /*-------------------------------------------------------------------------*/
    int sttsGetSpecialEff(int* pnEffectIdx);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /**
     * \brief		Convert the input text to it's pinying sequence
     * \param	szText		[in]	the text needs to be synthesised
     * \param	nEncodeType	[in]	1-GB,  2-GBK traditional,  3-BIG5, others-程序自动判断
     * \param	szPinyin	[out]	the pinyin sequence
     * \return	0: failed			1: success
     */
    /*-------------------------------------------------------------------------*/
    int sttsTextToPinyin(char *szText,int nEncodeType,char *szPinyin);
    
    
    
    
    
    
    /*-------------------------------------------------------------------------*/
    /*				The following functions are for internal use			   */
#ifdef __cplusplus
    
}

#endif





#endif

