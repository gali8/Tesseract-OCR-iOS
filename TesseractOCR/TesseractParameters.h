//
//  TesseractParameters.h
//  Tesseract OCR iOS
//  This code is auto-generated from include/tesseract/tesseractclass.h.
//
//  Created by Nikolay Volosatov on 13/12/14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_TesseractParameters_h
#define Tesseract_OCR_iOS_TesseractParameters_h

///%rej allowed before rej whole block
///@param Type double
///@param Default 45.00
extern NSString *const kTSTesseditRejectBlockPercent;

///good_quality_doc lte rejection limit
///@param Type double
///@param Default 0.08
extern NSString *const kTSQualityRejPc;

///Print paragraph debug info.
///@param Type INT
///@param Default 0
extern NSString *const kTSParagraphDebugLevel;

///alphas in a good word
///@param Type INT
///@param Default 2
extern NSString *const kTSQualityMinInitialAlphasReqd;

///Reward punctation joins
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditPreferJoinedPunct;

///Reject any x-ht lt or eq than this
///@param Type INT
///@param Default 8
extern NSString *const kTSMinSaneXHtPixels;

///Write block separators in output
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditWriteBlockSeparators;

///Adaptation decision algorithm for tess
///@param Type INT
///@param Default 3
extern NSString *const kTSTesseditTestAdaptionMode;

///Log matcher activity
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditMatcherLog;

///Extend permuter check
///@param Type BOOL
///@param Default false
extern NSString *const kTSRejAlphasInNumberPerm;

///POTENTIAL crunch garbage
///@param Type BOOL
///@param Default true
extern NSString *const kTSCrunchPotGarbage;

///How many non-noise blbs either side?
///@param Type INT
///@param Default 1
extern NSString *const kTSFixspNonNoiseLimit;

///Capture the image from the IPE
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditWriteImages;

///Dont Suspect dict wds longer than this
///@param Type INT
///@param Default 2
extern NSString *const kTSSuspectShortWords;

///Run interactively?
///@param Type BOOL
///@param Default false
extern NSString *const kTSInteractiveDisplayMode;

///Allow NN to unrej
///@param Type STRING
///@param Default "-?*\075"
extern NSString *const kTSOkRepeatedChNonAlphanumWds;

///crunch garbage cert lt this
///@param Type double
///@param Default -9.0
extern NSString *const kTSCrunchPoorGarbageCert;

///Dont reject ANYTHING
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditZeroRejection;

///Rej blbs near image edge limit
///@param Type INT
///@param Default 2
extern NSString *const kTSTesseditImageBorder;

///Learn both character fragments (as is done in the special low exposure mode) as well as unfragmented characters.
///@param Type BOOL
///@param Default false
extern NSString *const kTSApplyboxLearnCharsAndCharFragsMode;

///Force all rep chars the same
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditConsistentReps;

///How many times worse certainty does a superscript position glyph need to be for us to try classifying it as a char with a different baseline?
///@param Type double
///@param Default 2.0
extern NSString *const kTSSuperscriptWorseCertainty;

///Output text with boxes
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditCreateBoxfile;

///Mark v.bad words for tilde crunch
///@param Type BOOL
///@param Default true
extern NSString *const kTSUnlvTildeCrunching;

///Individual rejection control
///@param Type BOOL
///@param Default true
extern NSString *const kTSRejUseTessBlanks;

///A superscript scaled down more than this is unbelievably small.  For example, 0.3 means we expect the font size to be no smaller than 30% of the text line font size.
///@param Type double
///@param Default 0.4
extern NSString *const kTSSuperscriptScaledownRatio;

///Debug level for TessdataManager functions.
///@param Type INT
///@param Default 0
extern NSString *const kTSTessdataManagerDebugLevel;

///Extend permuter check
///@param Type BOOL
///@param Default false
extern NSString *const kTSRejUseSensibleWd;

///Use acceptability in okstring
///@param Type BOOL
///@param Default true
extern NSString *const kTSCrunchAcceptOk;

///-1 -> All pages, else specifc page to process
///@param Type INT
///@param Default -1
extern NSString *const kTSTesseditPageNumber;

///good_quality_doc gte good char limit
///@param Type double
///@param Default 1.1
extern NSString *const kTSQualityRowrejPc;

///Min suspect level for rejecting spaces
///@param Type INT
///@param Default 100
extern NSString *const kTSSuspectSpaceLevel;

///Output data to debug file
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDebugQualityMetrics;

///Debug level for sub & superscript fixer
///@param Type INT
///@param Default 0
extern NSString *const kTSSuperscriptDebug;

///Page number to apply boxes from
///@param Type INT
///@param Default 0
extern NSString *const kTSApplyboxPage;

///UNLV keep 1Il chars rejected
///@param Type BOOL
///@param Default false
extern NSString *const kTSSuspectConstrain1Il;

///For adj length in rating per ch
///@param Type INT
///@param Default 10
extern NSString *const kTSCrunchRatingMax;

///Call Tess to learn blobs
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditTrainingTess;

///Each bounding box is assumed to contain ngrams. Only learn the ngrams whose outlines overlap horizontally.
///@param Type BOOL
///@param Default false
extern NSString *const kTSApplyboxLearnNgramsMode;

///Aspect ratio dot/hyphen test
///@param Type double
///@param Default 1.5
extern NSString *const kTSTesseditLowerFlipHyphen;

///Conversion of word/line box file to char box file
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditResegmentFromLineBoxes;

///Leading punctuation
///@param Type STRING
///@param Default "('`\""
extern NSString *const kTSChsLeadingPunct;

///Write repetition char code
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditWriteRepCodes;

///Non standard number of outlines
///@param Type STRING
///@param Default "%| "
extern NSString *const kTSOutlinesOdd;

///Try to improve fuzzy spaces
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditFixFuzzySpaces;

///According to dict_word
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditOverridePermuter;

///, Punct. chs expected WITHIN numbers
///@param Type STRING
///@param Default ".
extern NSString *const kTSNumericPunctuation;

///Il1 conflict set
///@param Type STRING
///@param Default "Il1[]"
extern NSString *const kTSConflictSetIL1;

///Add words to the document dictionary
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditEnableDocDict;

///Small if lt xht x this
///@param Type double
///@param Default 0.6
extern NSString *const kTSCrunchSmallOutlinesSize;

///xcoord
///@param Type double
///@param Default 99999.99
extern NSString *const kTSTestPtX;

///ycoord
///@param Type double
///@param Default 99999.99
extern NSString *const kTSTestPtY;

///As it says
///@param Type INT
///@param Default 0
extern NSString *const kTSCrunchDebug;

///%rej allowed before rej whole doc
///@param Type double
///@param Default 65.00
extern NSString *const kTSTesseditRejectDocPercent;

///Allow outline errs in unrejection?
///@param Type BOOL
///@param Default false
extern NSString *const kTSDocqualExcuseOutlineErrs;

///Suspect marker level
///@param Type INT
///@param Default 99
extern NSString *const kTSSuspectLevel;

///Debug level
///@param Type INT
///@param Default 1
extern NSString *const kTSApplyboxDebug;

///Debug line finding
///@param Type BOOL
///@param Default false
extern NSString *const kTSTextordTabfindShowVlines;

///Del if word ht gt xht x this
///@param Type double
///@param Default 3.0
extern NSString *const kTSCrunchDelMaxHt;

///Reestimate debug
///@param Type INT
///@param Default 0
extern NSString *const kTSDebugXHtLevel;

///Dont touch bad rating limit
///@param Type double
///@param Default 999.9
extern NSString *const kTSSuspectRatingPerCh;

///Take out ~^ early?
///@param Type BOOL
///@param Default false
extern NSString *const kTSCrunchEarlyConvertBadUnlvChs;

///Page stats
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDebugDocRejection;

///Amount of debug output for bigram correction.
///@param Type INT
///@param Default 0
extern NSString *const kTSTesseditBigramDebug;

///Generate more boxes from boxed chars
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditMakeBoxesFromBoxes;

///Use word segmentation quality metric
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDontBlkrejGoodWds;

///Enable correction based on the word bigram dictionary.
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditEnableBigramCorrection;

///good_quality_doc lte outline error limit
///@param Type double
///@param Default 1.0
extern NSString *const kTSQualityOutlinePc;

///Only preserve wds longer than this
///@param Type INT
///@param Default 2
extern NSString *const kTSTesseditPreserveMinWdLen;

///Use word segmentation quality metric
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDontRowrejGoodWds;

///Only rej partially rejected words in row rejection
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditPreserveRowRejPerfectWds;

///Write .unlv output file
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditWriteUnlv;

///Print timing stats
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditTimingDebug;

///Min acceptable orientation margin
///@param Type double
///@param Default 7.0
extern NSString *const kTSMinOrientationMargin;

///%rej allowed before rej whole row
///@param Type double
///@param Default 40.00
extern NSString *const kTSTesseditRejectRowPercent;

///Turn on equation detector
///@param Type BOOL
///@param Default false
extern NSString *const kTSTextordEquationDetect;

///Before word crunch?
///@param Type BOOL
///@param Default true
extern NSString *const kTSCrunchEarlyMergeTessFails;

///Take segmentation and labeling from box file
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditResegmentFromBoxes;

///Use dictword test
///@param Type BOOL
///@param Default false
extern NSString *const kTSRej1IlUseDictWord;

///Draw output words
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDisplayOutwords;

///Generate training data from boxed chars
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditTrainFromBoxes;

///Blacklist of chars not to recognize
///@param Type STRING
///@param Default ""
extern NSString *const kTSTesseditCharBlacklist;

///unrej potential with no chekcs
///@param Type BOOL
///@param Default false
extern NSString *const kTSBlandUnrej;

///Run in parallel where possible
///@param Type INT
///@param Default 0
extern NSString *const kTSTesseditParallelize;

///Dont crunch words with long lower case strings
///@param Type INT
///@param Default 4
extern NSString *const kTSCrunchLeaveUcStrings;

///Display unsorted blobs
///@param Type BOOL
///@param Default false
extern NSString *const kTSTextordShowBlobs;

///In multilingual mode use params model of the primary language
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditUsePrimaryParamsModel;

///Reject all bad quality wds
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditRejectBadQualWds;

///Del if word gt xht x this below bl
///@param Type double
///@param Default 0.5
extern NSString *const kTSCrunchDelLowWord;

///Adaption debug
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditRejectionDebug;

///Debug level for BiDi
///@param Type INT
///@param Default 0
extern NSString *const kTSBidiDebug;

///Reject spaces?
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditUseRejectSpaces;

///good_quality_doc gte good char limit
///@param Type double
///@param Default 0.95
extern NSString *const kTSQualityCharPc;

///Del if word width lt xht x this
///@param Type double
///@param Default 3.0
extern NSString *const kTSCrunchDelMinWidth;

///Write .pdf output file
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditCreatePdf;

///crunch rating lt this
///@param Type double
///@param Default 80.0
extern NSString *const kTSCrunchTerribleRating;

///Dump intermediate images made during page segmentation
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDumpPagesegImages;

///Block and Row stats
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDebugBlockRejection;

///Use DOC dawg in 11l conf. detector
///@param Type BOOL
///@param Default false
extern NSString *const kTSRejTrustDocDawg;

///Min change in xht before actually trying it
///@param Type INT
///@param Default 8
extern NSString *const kTSXHtMinChange;

///How many potential indicators needed
///@param Type INT
///@param Default 1
extern NSString *const kTSCrunchPotIndicators;

///Only reject tess failures
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditMinimalRejection;

///Small if lt xht x this
///@param Type double
///@param Default 0.28
extern NSString *const kTSFixspSmallOutlinesSize;

///What reduction in badness do we think sufficient to choose a superscript over what we'd thought.  For example, a value of 0.6 means we want to reduce badness of certainty by 40%
///@param Type double
///@param Default 0.97
extern NSString *const kTSSuperscriptBetteredCertainty;

///Minimum bottom of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a superscript.
///@param Type double
///@param Default 0.3
extern NSString *const kTSSuperscriptMinYBottom;

///Fiddle alpha figures
///@param Type BOOL
///@param Default false
extern NSString *const kTSCrunchIncludeNumerals;

///Reduce rejection on good docs
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditGoodQualityUnrej;

///List of languages to load with this one
///@param Type STRING
///@param Default ""
extern NSString *const kTSTesseditLoadSublangs;

///Whitelist of chars to recognize
///@param Type STRING
///@param Default ""
extern NSString *const kTSTesseditCharWhitelist;

///Contextual fixspace debug
///@param Type INT
///@param Default 0
extern NSString *const kTSDebugFixSpaceLevel;

///Filename extension
///@param Type STRING
///@param Default ".tif"
extern NSString *const kTSFileType;

///Number of row rejects in whole word rejects which prevents whole row rejection
///@param Type double
///@param Default 70.00
extern NSString *const kTSTesseditWholeWdRejRowPercent;

///Crunch words with long repetitions
///@param Type INT
///@param Default 3
extern NSString *const kTSCrunchLongRepetitions;

///Maximum top of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a subscript.
///@param Type double
///@param Default 0.5
extern NSString *const kTSSubscriptMaxYTop;

///Use CJK fixed pitch model
///@param Type BOOL
///@param Default FALSE
extern NSString *const kTSTextordUseCjkFpModel;

///Individual rejection control
///@param Type BOOL
///@param Default true
extern NSString *const kTSRejUseGoodPerm;

///Test adaption criteria
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditTestAdaption;

///Del if word gt xht x this above bl
///@param Type double
///@param Default 1.5
extern NSString *const kTSCrunchDelHighWord;

///Apply row rejection to good docs
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditRowRejGoodDocs;

///Test for point
///@param Type BOOL
///@param Default false
extern NSString *const kTSTestPt;

///Page seg mode: 0=osd only, 1=auto+osd, 2=auto, 3=col, 4=block, 5=line, 6=word, 7=char (Values from PageSegMode enum in publictypes.h)
///@param Type INT
///@param Default PSM_SINGLE_BLOCK
extern NSString *const kTSTesseditPagesegMode;

///1st Trailing punctuation
///@param Type STRING
///@param Default ").,;:?!"
extern NSString *const kTSChsTrailingPunct1;

///2nd Trailing punctuation
///@param Type STRING
///@param Default ")'`\""
extern NSString *const kTSChsTrailingPunct2;

///What constitues done for spacing
///@param Type INT
///@param Default 1
extern NSString *const kTSFixspDoneMode;

///Max allowed deviation of blob top outside of font data
///@param Type INT
///@param Default 8
extern NSString *const kTSXHtAcceptanceTolerance;

///Dont double check
///@param Type BOOL
///@param Default true
extern NSString *const kTSRej1IlTrustPermuterType;

///Dont bother with word plausibility
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditUnrejAnyWd;

///Print cube debug info.
///@param Type INT
///@param Default 1
extern NSString *const kTSCubeDebugLevel;

///Dont crunch words with long lower case strings
///@param Type INT
///@param Default 4
extern NSString *const kTSCrunchLeaveLcStrings;

///Run paragraph detection on the post-text-recognition (more accurate)
///@param Type BOOL
///@param Default true
extern NSString *const kTSParagraphTextBased;

///POTENTIAL crunch cert lt this
///@param Type double
///@param Default -10.0
extern NSString *const kTSCrunchDelCert;

///Generate and print debug information for adaption
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditAdaptionDebug;

///good_quality_doc gte good blobs limit
///@param Type double
///@param Default 0.0
extern NSString *const kTSQualityBlobPc;

///Del if word ht lt xht x this
///@param Type double
///@param Default 0.7
extern NSString *const kTSCrunchDelMinHt;

///Allow feature extractors to see the original outline
///@param Type BOOL
///@param Default false
extern NSString *const kTSPolyAllowDetailedFx;

///Adaptation decision algorithm for tess
///@param Type INT
///@param Default 0x27
extern NSString *const kTSTesseditTessAdaptionMode;

///Only rej partially rejected words in block rejection
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditPreserveBlkRejPerfectWds;

///Dont pot crunch sensible strings
///@param Type BOOL
///@param Default false
extern NSString *const kTSCrunchLeaveAcceptStrings;

///Which OCR engine(s) to run (Tesseract, Cube, both). Defaults to loading and running only Tesseract (no Cube, no combiner). (Values from OcrEngineMode enum in tesseractclass.h)
///@param Type INT
///@param Default tesseract::OEM_TESSERACT_ONLY
extern NSString *const kTSTesseditOcrEngineMode;

///Check/Correct x-height
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditRedoXheight;

///Rejection algorithm
///@param Type INT
///@param Default 0
extern NSString *const kTSTesseditRejectMode;

///As it says
///@param Type BOOL
///@param Default true
extern NSString *const kTSCrunchTerribleGarbage;

///rej good doc wd if more than this fraction rejected
///@param Type double
///@param Default 1.1
extern NSString *const kTSTesseditGoodDocStillRowrejWd;

///POTENTIAL crunch rating lt this
///@param Type double
///@param Default 40
extern NSString *const kTSCrunchPotPoorRate;

///Make output have exactly one word per WERD
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditWordForWord;

///Exposure value follows this pattern in the image filename. The name of the image files are expected to be in the form [lang].[fontname].exp[num].tif
///@param Type STRING
///@param Default ".exp"
extern NSString *const kTSApplyboxExposurePattern;

///crunch garbage rating lt this
///@param Type double
///@param Default 60
extern NSString *const kTSCrunchPoorGarbageRate;

///Output char for unidentified blobs
///@param Type STRING
///@param Default "|"
extern NSString *const kTSUnrecognisedChar;

///Accept good rating limit
///@param Type double
///@param Default -999.9
extern NSString *const kTSSuspectAcceptRating;

///Crunch double hyphens?
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditFixHyphens;

///Perform training for ambiguities
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditAmbigsTraining;

///Dont reject ANYTHING AT ALL
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditZeroKelvinRejection;

///POTENTIAL crunch cert lt this
///@param Type double
///@param Default -8.0
extern NSString *const kTSCrunchPotPoorCert;

///Only initialize with the config file. Useful if the instance is not going to be used for OCR but say only for layout analysis.
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditInitConfigOnly;

///Non standard number of outlines
///@param Type STRING
///@param Default "ij!?%\":;"
extern NSString *const kTSOutlines2;

///Individual rejection control
///@param Type BOOL
///@param Default true
extern NSString *const kTSRejUseTessAccepted;

///Contextual 0O O0 flips
///@param Type BOOL
///@param Default true
extern NSString *const kTSTesseditFlip0O;

///Write all parameters to the given file.
///@param Type STRING
///@param Default ""
extern NSString *const kTSTesseditWriteParamsToFile;

///Do minimal rejection on pass 1 output
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditMinimalRejPass1;

///Output font info per char
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDebugFonts;

///Dont touch sensible strings
///@param Type BOOL
///@param Default true
extern NSString *const kTSCrunchLeaveOkStrings;

///Dump word pass/fail chk
///@param Type BOOL
///@param Default false
extern NSString *const kTSDebugAcceptableWds;

///Dump char choices
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditDumpChoices;

///POTENTIAL crunch rating lt this
///@param Type double
///@param Default 60
extern NSString *const kTSCrunchDelRating;

///Write .html hOCR output file
///@param Type BOOL
///@param Default false
extern NSString *const kTSTesseditCreateHocr;

///if >this fract
///@param Type double
///@param Default 0.85
extern NSString *const kTSRejWholeOfMostlyRejectWordFract;

///Aspect ratio dot/hyphen test
///@param Type double
///@param Default 1.8
extern NSString *const kTSTesseditUpperFlipHyphen;

///use new state cost heuristics for segmentation state evaluation
///@param Type BOOL
///@param Default FALSE
extern NSString *const kTSUseNewStateCost DEPRECATED_ATTRIBUTE;

///weight associated with seam cut in combined cost of state
///@param Type double
///@param Default 0
extern NSString *const kTSHeuristicWeightSeamcut DEPRECATED_ATTRIBUTE;

///char permutation debug
///@param Type BOOL
///@param Default 0
extern NSString *const kTSPermuteDebug DEPRECATED_ATTRIBUTE;

///max char width-to-height ratio allowed in segmentation
///@param Type double
///@param Default 2.0
extern NSString *const kTSHeuristicMaxCharWhRatio DEPRECATED_ATTRIBUTE;

///Run only the top choice permuter
///@param Type BOOL
///@param Default false
extern NSString *const kTSPermuteOnlyTop DEPRECATED_ATTRIBUTE;

///Acceptance decision algorithm
///@param Type INT
///@param Default 5
extern NSString *const kTSTesseditOkMode DEPRECATED_ATTRIBUTE;

///Turn on word script consistency permuter
///@param Type BOOL
///@param Default 0
extern NSString *const kTSPermuteScriptWord DEPRECATED_ATTRIBUTE;

///weight associated with char rating in combined cost of state
///@param Type double
///@param Default 1
extern NSString *const kTSHeuristicWeightRating DEPRECATED_ATTRIBUTE;

///incorporate segmentation cost in word rating?
///@param Type BOOL
///@param Default 0
extern NSString *const kTSSegmentSegcostRating DEPRECATED_ATTRIBUTE;

///Turn on character type (property) consistency permuter
///@param Type BOOL
///@param Default 0
extern NSString *const kTSPermuteChartypeWord DEPRECATED_ATTRIBUTE;

///Score multipler for script consistency within a word. Being a 'reward' factor, it should be <= 1. Smaller value implies bigger reward.
///@param Type double
///@param Default 0.95
extern NSString *const kTSSegmentRewardScript DEPRECATED_ATTRIBUTE;

///Maximum character width-to-height ratio for fixed pitch fonts
///@param Type double
///@param Default 2.0
extern NSString *const kTSSegsearchMaxFixedPitchCharWhRatio DEPRECATED_ATTRIBUTE;

///Score multipler for char type consistency within a word.
///@param Type double
///@param Default 0.97
extern NSString *const kTSSegmentRewardChartype DEPRECATED_ATTRIBUTE;

///Score multipler for ngram permuter's best choice (only used in the Han script path).
///@param Type double
///@param Default 0.99
extern NSString *const kTSSegmentRewardNgramBestChoice DEPRECATED_ATTRIBUTE;

///Multiplying factor of current best rate to prune other hypotheses
///@param Type double
///@param Default 2.0
extern NSString *const kTSBestratePruningFactor DEPRECATED_ATTRIBUTE;

///base factor for adding segmentation cost into word rating. It's a multiplying factor, the larger the value above 1, the bigger the effect of segmentation cost.
///@param Type double
///@param Default 1.25
extern NSString *const kTSHeuristicSegcostRatingBase DEPRECATED_ATTRIBUTE;

///Load fixed length dawgs (e.g. for non-space delimited languages)
///@param Type BOOL
///@param Default true
extern NSString *const kTSLoadFixedLengthDawgs DEPRECATED_ATTRIBUTE;

///weight associated with width evidence in combined cost of state
///@param Type double
///@param Default 1000.0
extern NSString *const kTSHeuristicWeightWidth DEPRECATED_ATTRIBUTE;

///Debug the whole segmentation process
///@param Type INT
///@param Default 0
extern NSString *const kTSSegmentDebug DEPRECATED_ATTRIBUTE;

///Activate character-level n-gram-based permuter
///@param Type BOOL
///@param Default false
extern NSString *const kTSNgramPermuterActivated DEPRECATED_ATTRIBUTE;

///Depth of blob choice lists to explore when fixed length dawgs are on
///@param Type INT
///@param Default 3
extern NSString *const kTSLanguageModelFixedLengthChoicesDepth DEPRECATED_ATTRIBUTE;

///Enable new segmentation search path.
///@param Type BOOL
///@param Default false
extern NSString *const kTSEnableNewSegsearch DEPRECATED_ATTRIBUTE;

///Turn on fixed-length phrasebook search permuter
///@param Type BOOL
///@param Default 0
extern NSString *const kTSPermuteFixedLengthDawg DEPRECATED_ATTRIBUTE;

#endif
