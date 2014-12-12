//
//  TesseractParameters.h
//  Tesseract OCR iOS
//  This code is auto-generated from include/tesseract/tesseractclass.h.
//
//  Created by Nikolay Volosatov on 12/12/14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_TesseractParameters_h
#define Tesseract_OCR_iOS_TesseractParameters_h

//%rej allowed before rej whole block
//Type: double
//Default: 45.00
extern NSString *const kTSTesseditRejectBlockPercent;

//good_quality_doc lte rejection limit
//Type: double
//Default: 0.08
extern NSString *const kTSQualityRejPc;

//Print paragraph debug info.
//Type: INT
//Default: 0
extern NSString *const kTSParagraphDebugLevel;

//alphas in a good word
//Type: INT
//Default: 2
extern NSString *const kTSQualityMinInitialAlphasReqd;

//Reward punctation joins
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditPreferJoinedPunct;

//Reject any x-ht lt or eq than this
//Type: INT
//Default: 8
extern NSString *const kTSMinSaneXHtPixels;

//Write block separators in output
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditWriteBlockSeparators;

//Adaptation decision algorithm for tess
//Type: INT
//Default: 3
extern NSString *const kTSTesseditTestAdaptionMode;

//Log matcher activity
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditMatcherLog;

//Extend permuter check
//Type: BOOL
//Default: false
extern NSString *const kTSRejAlphasInNumberPerm;

//POTENTIAL crunch garbage
//Type: BOOL
//Default: true
extern NSString *const kTSCrunchPotGarbage;

//How many non-noise blbs either side?
//Type: INT
//Default: 1
extern NSString *const kTSFixspNonNoiseLimit;

//Capture the image from the IPE
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditWriteImages;

//Dont Suspect dict wds longer than this
//Type: INT
//Default: 2
extern NSString *const kTSSuspectShortWords;

//Run interactively?
//Type: BOOL
//Default: false
extern NSString *const kTSInteractiveDisplayMode;

//Allow NN to unrej
//Type: STRING
//Default: "-?*\075"
extern NSString *const kTSOkRepeatedChNonAlphanumWds;

//crunch garbage cert lt this
//Type: double
//Default: -9.0
extern NSString *const kTSCrunchPoorGarbageCert;

//Dont reject ANYTHING
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditZeroRejection;

//Rej blbs near image edge limit
//Type: INT
//Default: 2
extern NSString *const kTSTesseditImageBorder;

//Learn both character fragments (as is done in the special low exposure mode) as well as unfragmented characters.
//Type: BOOL
//Default: false
extern NSString *const kTSApplyboxLearnCharsAndCharFragsMode;

//Force all rep chars the same
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditConsistentReps;

//How many times worse certainty does a superscript position glyph need to be for us to try classifying it as a char with a different baseline?
//Type: double
//Default: 2.0
extern NSString *const kTSSuperscriptWorseCertainty;

//Output text with boxes
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditCreateBoxfile;

//Mark v.bad words for tilde crunch
//Type: BOOL
//Default: true
extern NSString *const kTSUnlvTildeCrunching;

//Individual rejection control
//Type: BOOL
//Default: true
extern NSString *const kTSRejUseTessBlanks;

//A superscript scaled down more than this is unbelievably small.  For example, 0.3 means we expect the font size to be no smaller than 30% of the text line font size.
//Type: double
//Default: 0.4
extern NSString *const kTSSuperscriptScaledownRatio;

//Debug level for TessdataManager functions.
//Type: INT
//Default: 0
extern NSString *const kTSTessdataManagerDebugLevel;

//Extend permuter check
//Type: BOOL
//Default: false
extern NSString *const kTSRejUseSensibleWd;

//Use acceptability in okstring
//Type: BOOL
//Default: true
extern NSString *const kTSCrunchAcceptOk;

//-1 -> All pages, else specifc page to process
//Type: INT
//Default: -1
extern NSString *const kTSTesseditPageNumber;

//good_quality_doc gte good char limit
//Type: double
//Default: 1.1
extern NSString *const kTSQualityRowrejPc;

//Min suspect level for rejecting spaces
//Type: INT
//Default: 100
extern NSString *const kTSSuspectSpaceLevel;

//Output data to debug file
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDebugQualityMetrics;

//Debug level for sub & superscript fixer
//Type: INT
//Default: 0
extern NSString *const kTSSuperscriptDebug;

//Page number to apply boxes from
//Type: INT
//Default: 0
extern NSString *const kTSApplyboxPage;

//UNLV keep 1Il chars rejected
//Type: BOOL
//Default: false
extern NSString *const kTSSuspectConstrain1Il;

//For adj length in rating per ch
//Type: INT
//Default: 10
extern NSString *const kTSCrunchRatingMax;

//Call Tess to learn blobs
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditTrainingTess;

//Each bounding box is assumed to contain ngrams. Only learn the ngrams whose outlines overlap horizontally.
//Type: BOOL
//Default: false
extern NSString *const kTSApplyboxLearnNgramsMode;

//Aspect ratio dot/hyphen test
//Type: double
//Default: 1.5
extern NSString *const kTSTesseditLowerFlipHyphen;

//Conversion of word/line box file to char box file
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditResegmentFromLineBoxes;

//Leading punctuation
//Type: STRING
//Default: "('`\""
extern NSString *const kTSChsLeadingPunct;

//Write repetition char code
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditWriteRepCodes;

//Non standard number of outlines
//Type: STRING
//Default: "%| "
extern NSString *const kTSOutlinesOdd;

//Try to improve fuzzy spaces
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditFixFuzzySpaces;

//According to dict_word
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditOverridePermuter;

//, Punct. chs expected WITHIN numbers
//Type: STRING
//Default: ".
extern NSString *const kTSNumericPunctuation;

//Il1 conflict set
//Type: STRING
//Default: "Il1[]"
extern NSString *const kTSConflictSetIL1;

//Add words to the document dictionary
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditEnableDocDict;

//Small if lt xht x this
//Type: double
//Default: 0.6
extern NSString *const kTSCrunchSmallOutlinesSize;

//xcoord
//Type: double
//Default: 99999.99
extern NSString *const kTSTestPtX;

//ycoord
//Type: double
//Default: 99999.99
extern NSString *const kTSTestPtY;

//As it says
//Type: INT
//Default: 0
extern NSString *const kTSCrunchDebug;

//%rej allowed before rej whole doc
//Type: double
//Default: 65.00
extern NSString *const kTSTesseditRejectDocPercent;

//Allow outline errs in unrejection?
//Type: BOOL
//Default: false
extern NSString *const kTSDocqualExcuseOutlineErrs;

//Suspect marker level
//Type: INT
//Default: 99
extern NSString *const kTSSuspectLevel;

//Debug level
//Type: INT
//Default: 1
extern NSString *const kTSApplyboxDebug;

//Debug line finding
//Type: BOOL
//Default: false
extern NSString *const kTSTextordTabfindShowVlines;

//Del if word ht gt xht x this
//Type: double
//Default: 3.0
extern NSString *const kTSCrunchDelMaxHt;

//Reestimate debug
//Type: INT
//Default: 0
extern NSString *const kTSDebugXHtLevel;

//Dont touch bad rating limit
//Type: double
//Default: 999.9
extern NSString *const kTSSuspectRatingPerCh;

//Take out ~^ early?
//Type: BOOL
//Default: false
extern NSString *const kTSCrunchEarlyConvertBadUnlvChs;

//Page stats
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDebugDocRejection;

//Amount of debug output for bigram correction.
//Type: INT
//Default: 0
extern NSString *const kTSTesseditBigramDebug;

//Generate more boxes from boxed chars
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditMakeBoxesFromBoxes;

//Use word segmentation quality metric
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDontBlkrejGoodWds;

//Enable correction based on the word bigram dictionary.
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditEnableBigramCorrection;

//good_quality_doc lte outline error limit
//Type: double
//Default: 1.0
extern NSString *const kTSQualityOutlinePc;

//Only preserve wds longer than this
//Type: INT
//Default: 2
extern NSString *const kTSTesseditPreserveMinWdLen;

//Use word segmentation quality metric
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDontRowrejGoodWds;

//Only rej partially rejected words in row rejection
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditPreserveRowRejPerfectWds;

//Write .unlv output file
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditWriteUnlv;

//Print timing stats
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditTimingDebug;

//Min acceptable orientation margin
//Type: double
//Default: 7.0
extern NSString *const kTSMinOrientationMargin;

//%rej allowed before rej whole row
//Type: double
//Default: 40.00
extern NSString *const kTSTesseditRejectRowPercent;

//Turn on equation detector
//Type: BOOL
//Default: false
extern NSString *const kTSTextordEquationDetect;

//Before word crunch?
//Type: BOOL
//Default: true
extern NSString *const kTSCrunchEarlyMergeTessFails;

//Take segmentation and labeling from box file
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditResegmentFromBoxes;

//Use dictword test
//Type: BOOL
//Default: false
extern NSString *const kTSRej1IlUseDictWord;

//Draw output words
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDisplayOutwords;

//Generate training data from boxed chars
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditTrainFromBoxes;

//Blacklist of chars not to recognize
//Type: STRING
//Default: ""
extern NSString *const kTSTesseditCharBlacklist;

//unrej potential with no chekcs
//Type: BOOL
//Default: false
extern NSString *const kTSBlandUnrej;

//Run in parallel where possible
//Type: INT
//Default: 0
extern NSString *const kTSTesseditParallelize;

//Dont crunch words with long lower case strings
//Type: INT
//Default: 4
extern NSString *const kTSCrunchLeaveUcStrings;

//Display unsorted blobs
//Type: BOOL
//Default: false
extern NSString *const kTSTextordShowBlobs;

//In multilingual mode use params model of the primary language
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditUsePrimaryParamsModel;

//Reject all bad quality wds
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditRejectBadQualWds;

//Del if word gt xht x this below bl
//Type: double
//Default: 0.5
extern NSString *const kTSCrunchDelLowWord;

//Adaption debug
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditRejectionDebug;

//Debug level for BiDi
//Type: INT
//Default: 0
extern NSString *const kTSBidiDebug;

//Reject spaces?
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditUseRejectSpaces;

//good_quality_doc gte good char limit
//Type: double
//Default: 0.95
extern NSString *const kTSQualityCharPc;

//Del if word width lt xht x this
//Type: double
//Default: 3.0
extern NSString *const kTSCrunchDelMinWidth;

//Write .pdf output file
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditCreatePdf;

//crunch rating lt this
//Type: double
//Default: 80.0
extern NSString *const kTSCrunchTerribleRating;

//Dump intermediate images made during page segmentation
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDumpPagesegImages;

//Block and Row stats
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDebugBlockRejection;

//Use DOC dawg in 11l conf. detector
//Type: BOOL
//Default: false
extern NSString *const kTSRejTrustDocDawg;

//Min change in xht before actually trying it
//Type: INT
//Default: 8
extern NSString *const kTSXHtMinChange;

//How many potential indicators needed
//Type: INT
//Default: 1
extern NSString *const kTSCrunchPotIndicators;

//Only reject tess failures
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditMinimalRejection;

//Small if lt xht x this
//Type: double
//Default: 0.28
extern NSString *const kTSFixspSmallOutlinesSize;

//What reduction in badness do we think sufficient to choose a superscript over what we'd thought.  For example, a value of 0.6 means we want to reduce badness of certainty by 40%
//Type: double
//Default: 0.97
extern NSString *const kTSSuperscriptBetteredCertainty;

//Minimum bottom of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a superscript.
//Type: double
//Default: 0.3
extern NSString *const kTSSuperscriptMinYBottom;

//Fiddle alpha figures
//Type: BOOL
//Default: false
extern NSString *const kTSCrunchIncludeNumerals;

//Reduce rejection on good docs
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditGoodQualityUnrej;

//List of languages to load with this one
//Type: STRING
//Default: ""
extern NSString *const kTSTesseditLoadSublangs;

//Whitelist of chars to recognize
//Type: STRING
//Default: ""
extern NSString *const kTSTesseditCharWhitelist;

//Contextual fixspace debug
//Type: INT
//Default: 0
extern NSString *const kTSDebugFixSpaceLevel;

//Filename extension
//Type: STRING
//Default: ".tif"
extern NSString *const kTSFileType;

//Number of row rejects in whole word rejects which prevents whole row rejection
//Type: double
//Default: 70.00
extern NSString *const kTSTesseditWholeWdRejRowPercent;

//Crunch words with long repetitions
//Type: INT
//Default: 3
extern NSString *const kTSCrunchLongRepetitions;

//Maximum top of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a subscript.
//Type: double
//Default: 0.5
extern NSString *const kTSSubscriptMaxYTop;

//Use CJK fixed pitch model
//Type: BOOL
//Default: FALSE
extern NSString *const kTSTextordUseCjkFpModel;

//Individual rejection control
//Type: BOOL
//Default: true
extern NSString *const kTSRejUseGoodPerm;

//Test adaption criteria
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditTestAdaption;

//Del if word gt xht x this above bl
//Type: double
//Default: 1.5
extern NSString *const kTSCrunchDelHighWord;

//Apply row rejection to good docs
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditRowRejGoodDocs;

//Test for point
//Type: BOOL
//Default: false
extern NSString *const kTSTestPt;

//Page seg mode: 0=osd only, 1=auto+osd, 2=auto, 3=col, 4=block, 5=line, 6=word, 7=char (Values from PageSegMode enum in publictypes.h)
//Type: INT
//Default: PSM_SINGLE_BLOCK
extern NSString *const kTSTesseditPagesegMode;

//1st Trailing punctuation
//Type: STRING
//Default: ").,;:?!"
extern NSString *const kTSChsTrailingPunct1;

//2nd Trailing punctuation
//Type: STRING
//Default: ")'`\""
extern NSString *const kTSChsTrailingPunct2;

//What constitues done for spacing
//Type: INT
//Default: 1
extern NSString *const kTSFixspDoneMode;

//Max allowed deviation of blob top outside of font data
//Type: INT
//Default: 8
extern NSString *const kTSXHtAcceptanceTolerance;

//Dont double check
//Type: BOOL
//Default: true
extern NSString *const kTSRej1IlTrustPermuterType;

//Dont bother with word plausibility
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditUnrejAnyWd;

//Print cube debug info.
//Type: INT
//Default: 1
extern NSString *const kTSCubeDebugLevel;

//Dont crunch words with long lower case strings
//Type: INT
//Default: 4
extern NSString *const kTSCrunchLeaveLcStrings;

//Run paragraph detection on the post-text-recognition (more accurate)
//Type: BOOL
//Default: true
extern NSString *const kTSParagraphTextBased;

//POTENTIAL crunch cert lt this
//Type: double
//Default: -10.0
extern NSString *const kTSCrunchDelCert;

//Generate and print debug information for adaption
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditAdaptionDebug;

//good_quality_doc gte good blobs limit
//Type: double
//Default: 0.0
extern NSString *const kTSQualityBlobPc;

//Del if word ht lt xht x this
//Type: double
//Default: 0.7
extern NSString *const kTSCrunchDelMinHt;

//Allow feature extractors to see the original outline
//Type: BOOL
//Default: false
extern NSString *const kTSPolyAllowDetailedFx;

//Adaptation decision algorithm for tess
//Type: INT
//Default: 0x27
extern NSString *const kTSTesseditTessAdaptionMode;

//Only rej partially rejected words in block rejection
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditPreserveBlkRejPerfectWds;

//Dont pot crunch sensible strings
//Type: BOOL
//Default: false
extern NSString *const kTSCrunchLeaveAcceptStrings;

//Which OCR engine(s) to run (Tesseract, Cube, both). Defaults to loading and running only Tesseract (no Cube, no combiner). (Values from OcrEngineMode enum in tesseractclass.h)
//Type: INT
//Default: tesseract::OEM_TESSERACT_ONLY
extern NSString *const kTSTesseditOcrEngineMode;

//Check/Correct x-height
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditRedoXheight;

//Rejection algorithm
//Type: INT
//Default: 0
extern NSString *const kTSTesseditRejectMode;

//As it says
//Type: BOOL
//Default: true
extern NSString *const kTSCrunchTerribleGarbage;

//rej good doc wd if more than this fraction rejected
//Type: double
//Default: 1.1
extern NSString *const kTSTesseditGoodDocStillRowrejWd;

//POTENTIAL crunch rating lt this
//Type: double
//Default: 40
extern NSString *const kTSCrunchPotPoorRate;

//Make output have exactly one word per WERD
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditWordForWord;

//Exposure value follows this pattern in the image filename. The name of the image files are expected to be in the form [lang].[fontname].exp[num].tif
//Type: STRING
//Default: ".exp"
extern NSString *const kTSApplyboxExposurePattern;

//crunch garbage rating lt this
//Type: double
//Default: 60
extern NSString *const kTSCrunchPoorGarbageRate;

//Output char for unidentified blobs
//Type: STRING
//Default: "|"
extern NSString *const kTSUnrecognisedChar;

//Accept good rating limit
//Type: double
//Default: -999.9
extern NSString *const kTSSuspectAcceptRating;

//Crunch double hyphens?
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditFixHyphens;

//Perform training for ambiguities
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditAmbigsTraining;

//Dont reject ANYTHING AT ALL
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditZeroKelvinRejection;

//POTENTIAL crunch cert lt this
//Type: double
//Default: -8.0
extern NSString *const kTSCrunchPotPoorCert;

//Only initialize with the config file. Useful if the instance is not going to be used for OCR but say only for layout analysis.
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditInitConfigOnly;

//Non standard number of outlines
//Type: STRING
//Default: "ij!?%\":;"
extern NSString *const kTSOutlines2;

//Individual rejection control
//Type: BOOL
//Default: true
extern NSString *const kTSRejUseTessAccepted;

//Contextual 0O O0 flips
//Type: BOOL
//Default: true
extern NSString *const kTSTesseditFlip0O;

//Write all parameters to the given file.
//Type: STRING
//Default: ""
extern NSString *const kTSTesseditWriteParamsToFile;

//Do minimal rejection on pass 1 output
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditMinimalRejPass1;

//Output font info per char
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDebugFonts;

//Dont touch sensible strings
//Type: BOOL
//Default: true
extern NSString *const kTSCrunchLeaveOkStrings;

//Dump word pass/fail chk
//Type: BOOL
//Default: false
extern NSString *const kTSDebugAcceptableWds;

//Dump char choices
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditDumpChoices;

//POTENTIAL crunch rating lt this
//Type: double
//Default: 60
extern NSString *const kTSCrunchDelRating;

//Write .html hOCR output file
//Type: BOOL
//Default: false
extern NSString *const kTSTesseditCreateHocr;

//if >this fract
//Type: double
//Default: 0.85
extern NSString *const kTSRejWholeOfMostlyRejectWordFract;

//Aspect ratio dot/hyphen test
//Type: double
//Default: 1.8
extern NSString *const kTSTesseditUpperFlipHyphen;

///
/// @warning deprecated parameter!
///
//use new state cost heuristics for segmentation state evaluation
//Type: BOOL
//Default: FALSE
extern NSString *const kTSUseNewStateCost;

///
/// @warning deprecated parameter!
///
//weight associated with seam cut in combined cost of state
//Type: double
//Default: 0
extern NSString *const kTSHeuristicWeightSeamcut;

///
/// @warning deprecated parameter!
///
//char permutation debug
//Type: BOOL
//Default: 0
extern NSString *const kTSPermuteDebug;

///
/// @warning deprecated parameter!
///
//max char width-to-height ratio allowed in segmentation
//Type: double
//Default: 2.0
extern NSString *const kTSHeuristicMaxCharWhRatio;

///
/// @warning deprecated parameter!
///
//Run only the top choice permuter
//Type: BOOL
//Default: false
extern NSString *const kTSPermuteOnlyTop;

///
/// @warning deprecated parameter!
///
//Acceptance decision algorithm
//Type: INT
//Default: 5
extern NSString *const kTSTesseditOkMode;

///
/// @warning deprecated parameter!
///
//Turn on word script consistency permuter
//Type: BOOL
//Default: 0
extern NSString *const kTSPermuteScriptWord;

///
/// @warning deprecated parameter!
///
//weight associated with char rating in combined cost of state
//Type: double
//Default: 1
extern NSString *const kTSHeuristicWeightRating;

///
/// @warning deprecated parameter!
///
//incorporate segmentation cost in word rating?
//Type: BOOL
//Default: 0
extern NSString *const kTSSegmentSegcostRating;

///
/// @warning deprecated parameter!
///
//Turn on character type (property) consistency permuter
//Type: BOOL
//Default: 0
extern NSString *const kTSPermuteChartypeWord;

///
/// @warning deprecated parameter!
///
//Score multipler for script consistency within a word. Being a 'reward' factor, it should be <= 1. Smaller value implies bigger reward.
//Type: double
//Default: 0.95
extern NSString *const kTSSegmentRewardScript;

///
/// @warning deprecated parameter!
///
//Maximum character width-to-height ratio for fixed pitch fonts
//Type: double
//Default: 2.0
extern NSString *const kTSSegsearchMaxFixedPitchCharWhRatio;

///
/// @warning deprecated parameter!
///
//Score multipler for char type consistency within a word.
//Type: double
//Default: 0.97
extern NSString *const kTSSegmentRewardChartype;

///
/// @warning deprecated parameter!
///
//Score multipler for ngram permuter's best choice (only used in the Han script path).
//Type: double
//Default: 0.99
extern NSString *const kTSSegmentRewardNgramBestChoice;

///
/// @warning deprecated parameter!
///
//Multiplying factor of current best rate to prune other hypotheses
//Type: double
//Default: 2.0
extern NSString *const kTSBestratePruningFactor;

///
/// @warning deprecated parameter!
///
//base factor for adding segmentation cost into word rating. It's a multiplying factor, the larger the value above 1, the bigger the effect of segmentation cost.
//Type: double
//Default: 1.25
extern NSString *const kTSHeuristicSegcostRatingBase;

///
/// @warning deprecated parameter!
///
//Load fixed length dawgs (e.g. for non-space delimited languages)
//Type: BOOL
//Default: true
extern NSString *const kTSLoadFixedLengthDawgs;

///
/// @warning deprecated parameter!
///
//weight associated with width evidence in combined cost of state
//Type: double
//Default: 1000.0
extern NSString *const kTSHeuristicWeightWidth;

///
/// @warning deprecated parameter!
///
//Debug the whole segmentation process
//Type: INT
//Default: 0
extern NSString *const kTSSegmentDebug;

///
/// @warning deprecated parameter!
///
//Activate character-level n-gram-based permuter
//Type: BOOL
//Default: false
extern NSString *const kTSNgramPermuterActivated;

///
/// @warning deprecated parameter!
///
//Depth of blob choice lists to explore when fixed length dawgs are on
//Type: INT
//Default: 3
extern NSString *const kTSLanguageModelFixedLengthChoicesDepth;

///
/// @warning deprecated parameter!
///
//Enable new segmentation search path.
//Type: BOOL
//Default: false
extern NSString *const kTSEnableNewSegsearch;

///
/// @warning deprecated parameter!
///
//Turn on fixed-length phrasebook search permuter
//Type: BOOL
//Default: 0
extern NSString *const kTSPermuteFixedLengthDawg;

#endif
