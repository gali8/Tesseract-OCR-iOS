//
//  G8TesseractParameters.h
//  Tesseract OCR iOS
//  This code is auto-generated from include/tesseract/tesseractclass.h.
//
//  Created by Nikolay Volosatov on 15/12/14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_G8TesseractParameters_h
#define Tesseract_OCR_iOS_G8TesseractParameters_h

///-1 -> All pages, else specifc page to process
///@param Type INT
///@param Default -1
extern NSString *const kG8TesseditPageNumber;

///Take out ~^ early?
///@param Type BOOL
///@param Default false
extern NSString *const kG8CrunchEarlyConvertBadUnlvChs;

///Dont touch sensible strings
///@param Type BOOL
///@param Default true
extern NSString *const kG8CrunchLeaveOkStrings;

///Reject spaces?
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditUseRejectSpaces;

///Reduce rejection on good docs
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditGoodQualityUnrej;

///Extend permuter check
///@param Type BOOL
///@param Default false
extern NSString *const kG8RejAlphasInNumberPerm;

///Display unsorted blobs
///@param Type BOOL
///@param Default false
extern NSString *const kG8TextordShowBlobs;

///Run paragraph detection on the post-text-recognition (more accurate)
///@param Type BOOL
///@param Default true
extern NSString *const kG8ParagraphTextBased;

///Only preserve wds longer than this
///@param Type INT
///@param Default 2
extern NSString *const kG8TesseditPreserveMinWdLen;

///Each bounding box is assumed to contain ngrams. Only learn the ngrams whose outlines overlap horizontally.
///@param Type BOOL
///@param Default false
extern NSString *const kG8ApplyboxLearnNgramsMode;

///good_quality_doc lte outline error limit
///@param Type double
///@param Default 1.0
extern NSString *const kG8QualityOutlinePc;

///Generate more boxes from boxed chars
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditMakeBoxesFromBoxes;

///Reject any x-ht lt or eq than this
///@param Type INT
///@param Default 8
extern NSString *const kG8MinSaneXHtPixels;

///Reward punctation joins
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditPreferJoinedPunct;

///Dont double check
///@param Type BOOL
///@param Default true
extern NSString *const kG8Rej1IlTrustPermuterType;

///POTENTIAL crunch cert lt this
///@param Type double
///@param Default -10.0
extern NSString *const kG8CrunchDelCert;

///Number of row rejects in whole word rejects which prevents whole row rejection
///@param Type double
///@param Default 70.00
extern NSString *const kG8TesseditWholeWdRejRowPercent;

///Suspect marker level
///@param Type INT
///@param Default 99
extern NSString *const kG8SuspectLevel;

///Del if word ht lt xht x this
///@param Type double
///@param Default 0.7
extern NSString *const kG8CrunchDelMinHt;

///As it says
///@param Type INT
///@param Default 0
extern NSString *const kG8CrunchDebug;

///Only reject tess failures
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditMinimalRejection;

///Adaptation decision algorithm for tess
///@param Type INT
///@param Default 0x27
extern NSString *const kG8TesseditTessAdaptionMode;

///Write all parameters to the given file.
///@param Type STRING
///@param Default ""
extern NSString *const kG8TesseditWriteParamsToFile;

///Max allowed deviation of blob top outside of font data
///@param Type INT
///@param Default 8
extern NSString *const kG8XHtAcceptanceTolerance;

///Minimum bottom of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a superscript.
///@param Type double
///@param Default 0.3
extern NSString *const kG8SuperscriptMinYBottom;

///POTENTIAL crunch garbage
///@param Type BOOL
///@param Default true
extern NSString *const kG8CrunchPotGarbage;

///Write .html hOCR output file
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditCreateHocr;

///Contextual fixspace debug
///@param Type INT
///@param Default 0
extern NSString *const kG8DebugFixSpaceLevel;

///Aspect ratio dot/hyphen test
///@param Type double
///@param Default 1.8
extern NSString *const kG8TesseditUpperFlipHyphen;

///crunch rating lt this
///@param Type double
///@param Default 80.0
extern NSString *const kG8CrunchTerribleRating;

///alphas in a good word
///@param Type INT
///@param Default 2
extern NSString *const kG8QualityMinInitialAlphasReqd;

///Page seg mode: 0=osd only, 1=auto+osd, 2=auto, 3=col, 4=block, 5=line, 6=word, 7=char (Values from PageSegMode enum in publictypes.h)
///@param Type INT
///@param Default PSM_SINGLE_BLOCK
extern NSString *const kG8TesseditPagesegMode;

///good_quality_doc gte good char limit
///@param Type double
///@param Default 1.1
extern NSString *const kG8QualityRowrejPc;

///POTENTIAL crunch cert lt this
///@param Type double
///@param Default -8.0
extern NSString *const kG8CrunchPotPoorCert;

///Enable correction based on the word bigram dictionary.
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditEnableBigramCorrection;

///Dump word pass/fail chk
///@param Type BOOL
///@param Default false
extern NSString *const kG8DebugAcceptableWds;

///crunch garbage cert lt this
///@param Type double
///@param Default -9.0
extern NSString *const kG8CrunchPoorGarbageCert;

///xcoord
///@param Type double
///@param Default 99999.99
extern NSString *const kG8TestPtX;

///ycoord
///@param Type double
///@param Default 99999.99
extern NSString *const kG8TestPtY;

///Run interactively?
///@param Type BOOL
///@param Default false
extern NSString *const kG8InteractiveDisplayMode;

///Output data to debug file
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDebugQualityMetrics;

///Del if word ht gt xht x this
///@param Type double
///@param Default 3.0
extern NSString *const kG8CrunchDelMaxHt;

///Run in parallel where possible
///@param Type INT
///@param Default 0
extern NSString *const kG8TesseditParallelize;

///Allow NN to unrej
///@param Type STRING
///@param Default "-?*\075"
extern NSString *const kG8OkRepeatedChNonAlphanumWds;

///Only rej partially rejected words in row rejection
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditPreserveRowRejPerfectWds;

///According to dict_word
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditOverridePermuter;

///, Punct. chs expected WITHIN numbers
///@param Type STRING
///@param Default ".
extern NSString *const kG8NumericPunctuation;

///Min change in xht before actually trying it
///@param Type INT
///@param Default 8
extern NSString *const kG8XHtMinChange;

///Only rej partially rejected words in block rejection
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditPreserveBlkRejPerfectWds;

///Write .unlv output file
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditWriteUnlv;

///Debug line finding
///@param Type BOOL
///@param Default false
extern NSString *const kG8TextordTabfindShowVlines;

///Debug level for sub & superscript fixer
///@param Type INT
///@param Default 0
extern NSString *const kG8SuperscriptDebug;

///Use word segmentation quality metric
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDontRowrejGoodWds;

///Reject all bad quality wds
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditRejectBadQualWds;

///crunch garbage rating lt this
///@param Type double
///@param Default 60
extern NSString *const kG8CrunchPoorGarbageRate;

///How many potential indicators needed
///@param Type INT
///@param Default 1
extern NSString *const kG8CrunchPotIndicators;

///Write repetition char code
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditWriteRepCodes;

///Rej blbs near image edge limit
///@param Type INT
///@param Default 2
extern NSString *const kG8TesseditImageBorder;

///Force all rep chars the same
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditConsistentReps;

///POTENTIAL crunch rating lt this
///@param Type double
///@param Default 60
extern NSString *const kG8CrunchDelRating;

///good_quality_doc gte good char limit
///@param Type double
///@param Default 0.95
extern NSString *const kG8QualityCharPc;

///Del if word gt xht x this above bl
///@param Type double
///@param Default 1.5
extern NSString *const kG8CrunchDelHighWord;

///Output font info per char
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDebugFonts;

///Log matcher activity
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditMatcherLog;

///Write .pdf output file
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditCreatePdf;

///A superscript scaled down more than this is unbelievably small.  For example, 0.3 means we expect the font size to be no smaller than 30% of the text line font size.
///@param Type double
///@param Default 0.4
extern NSString *const kG8SuperscriptScaledownRatio;

///What constitues done for spacing
///@param Type INT
///@param Default 1
extern NSString *const kG8FixspDoneMode;

///POTENTIAL crunch rating lt this
///@param Type double
///@param Default 40
extern NSString *const kG8CrunchPotPoorRate;

///As it says
///@param Type BOOL
///@param Default true
extern NSString *const kG8CrunchTerribleGarbage;

///Contextual 0O O0 flips
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditFlip0O;

///Individual rejection control
///@param Type BOOL
///@param Default true
extern NSString *const kG8RejUseGoodPerm;

///Dont touch bad rating limit
///@param Type double
///@param Default 999.9
extern NSString *const kG8SuspectRatingPerCh;

///What reduction in badness do we think sufficient to choose a superscript over what we'd thought.  For example, a value of 0.6 means we want to reduce badness of certainty by 40%
///@param Type double
///@param Default 0.97
extern NSString *const kG8SuperscriptBetteredCertainty;

///%rej allowed before rej whole doc
///@param Type double
///@param Default 65.00
extern NSString *const kG8TesseditRejectDocPercent;

///Allow feature extractors to see the original outline
///@param Type BOOL
///@param Default false
extern NSString *const kG8PolyAllowDetailedFx;

///rej good doc wd if more than this fraction rejected
///@param Type double
///@param Default 1.1
extern NSString *const kG8TesseditGoodDocStillRowrejWd;

///unrej potential with no chekcs
///@param Type BOOL
///@param Default false
extern NSString *const kG8BlandUnrej;

///Min acceptable orientation margin
///@param Type double
///@param Default 7.0
extern NSString *const kG8MinOrientationMargin;

///Aspect ratio dot/hyphen test
///@param Type double
///@param Default 1.5
extern NSString *const kG8TesseditLowerFlipHyphen;

///Page number to apply boxes from
///@param Type INT
///@param Default 0
extern NSString *const kG8ApplyboxPage;

///Conversion of word/line box file to char box file
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditResegmentFromLineBoxes;

///Debug level for BiDi
///@param Type INT
///@param Default 0
extern NSString *const kG8BidiDebug;

///In multilingual mode use params model of the primary language
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditUsePrimaryParamsModel;

///How many times worse certainty does a superscript position glyph need to be for us to try classifying it as a char with a different baseline?
///@param Type double
///@param Default 2.0
extern NSString *const kG8SuperscriptWorseCertainty;

///Add words to the document dictionary
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditEnableDocDict;

///good_quality_doc lte rejection limit
///@param Type double
///@param Default 0.08
extern NSString *const kG8QualityRejPc;

///Do minimal rejection on pass 1 output
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditMinimalRejPass1;

///good_quality_doc gte good blobs limit
///@param Type double
///@param Default 0.0
extern NSString *const kG8QualityBlobPc;

///Extend permuter check
///@param Type BOOL
///@param Default false
extern NSString *const kG8RejUseSensibleWd;

///Allow outline errs in unrejection?
///@param Type BOOL
///@param Default false
extern NSString *const kG8DocqualExcuseOutlineErrs;

///Which OCR engine(s) to run (Tesseract, Cube, both). Defaults to loading and running only Tesseract (no Cube, no combiner). (Values from OcrEngineMode enum in tesseractclass.h)
///@param Type INT
///@param Default tesseract::OEM_TESSERACT_ONLY
extern NSString *const kG8TesseditOcrEngineMode;

///Accept good rating limit
///@param Type double
///@param Default -999.9
extern NSString *const kG8SuspectAcceptRating;

///Generate and print debug information for adaption
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditAdaptionDebug;

///Before word crunch?
///@param Type BOOL
///@param Default true
extern NSString *const kG8CrunchEarlyMergeTessFails;

///Exposure value follows this pattern in the image filename. The name of the image files are expected to be in the form [lang].[fontname].exp[num].tif
///@param Type STRING
///@param Default ".exp"
extern NSString *const kG8ApplyboxExposurePattern;

///if >this fract
///@param Type double
///@param Default 0.85
extern NSString *const kG8RejWholeOfMostlyRejectWordFract;

///Debug level
///@param Type INT
///@param Default 1
extern NSString *const kG8ApplyboxDebug;

///Generate training data from boxed chars
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditTrainFromBoxes;

///Learn both character fragments (as is done in the special low exposure mode) as well as unfragmented characters.
///@param Type BOOL
///@param Default false
extern NSString *const kG8ApplyboxLearnCharsAndCharFragsMode;

///Debug level for TessdataManager functions.
///@param Type INT
///@param Default 0
extern NSString *const kG8TessdataManagerDebugLevel;

///Dont crunch words with long lower case strings
///@param Type INT
///@param Default 4
extern NSString *const kG8CrunchLeaveUcStrings;

///Apply row rejection to good docs
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditRowRejGoodDocs;

///Output char for unidentified blobs
///@param Type STRING
///@param Default "|"
extern NSString *const kG8UnrecognisedChar;

///Individual rejection control
///@param Type BOOL
///@param Default true
extern NSString *const kG8RejUseTessBlanks;

///Print cube debug info.
///@param Type INT
///@param Default 1
extern NSString *const kG8CubeDebugLevel;

///Print timing stats
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditTimingDebug;

///2nd Trailing punctuation
///@param Type STRING
///@param Default ")'`\""
extern NSString *const kG8ChsTrailingPunct2;

///Output text with boxes
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditCreateBoxfile;

///1st Trailing punctuation
///@param Type STRING
///@param Default ").,;:?!"
extern NSString *const kG8ChsTrailingPunct1;

///Write block separators in output
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditWriteBlockSeparators;

///Del if word gt xht x this below bl
///@param Type double
///@param Default 0.5
extern NSString *const kG8CrunchDelLowWord;

///UNLV keep 1Il chars rejected
///@param Type BOOL
///@param Default false
extern NSString *const kG8SuspectConstrain1Il;

///Crunch double hyphens?
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditFixHyphens;

///Dont reject ANYTHING AT ALL
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditZeroKelvinRejection;

///Use dictword test
///@param Type BOOL
///@param Default false
extern NSString *const kG8Rej1IlUseDictWord;

///Dont pot crunch sensible strings
///@param Type BOOL
///@param Default false
extern NSString *const kG8CrunchLeaveAcceptStrings;

///Min suspect level for rejecting spaces
///@param Type INT
///@param Default 100
extern NSString *const kG8SuspectSpaceLevel;

///Mark v.bad words for tilde crunch
///@param Type BOOL
///@param Default true
extern NSString *const kG8UnlvTildeCrunching;

///Perform training for ambiguities
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditAmbigsTraining;

///Blacklist of chars not to recognize
///@param Type STRING
///@param Default ""
extern NSString *const kG8TesseditCharBlacklist;

///Dont crunch words with long lower case strings
///@param Type INT
///@param Default 4
extern NSString *const kG8CrunchLeaveLcStrings;

///Turn on equation detector
///@param Type BOOL
///@param Default false
extern NSString *const kG8TextordEquationDetect;

///Make output have exactly one word per WERD
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditWordForWord;

///Try to improve fuzzy spaces
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditFixFuzzySpaces;

///Dump intermediate images made during page segmentation
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDumpPagesegImages;

///List of languages to load with this one
///@param Type STRING
///@param Default ""
extern NSString *const kG8TesseditLoadSublangs;

///For adj length in rating per ch
///@param Type INT
///@param Default 10
extern NSString *const kG8CrunchRatingMax;

///%rej allowed before rej whole row
///@param Type double
///@param Default 40.00
extern NSString *const kG8TesseditRejectRowPercent;

///Only initialize with the config file. Useful if the instance is not going to be used for OCR but say only for layout analysis.
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditInitConfigOnly;

///Capture the image from the IPE
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditWriteImages;

///%rej allowed before rej whole block
///@param Type double
///@param Default 45.00
extern NSString *const kG8TesseditRejectBlockPercent;

///Block and Row stats
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDebugBlockRejection;

///Fiddle alpha figures
///@param Type BOOL
///@param Default false
extern NSString *const kG8CrunchIncludeNumerals;

///Small if lt xht x this
///@param Type double
///@param Default 0.28
extern NSString *const kG8FixspSmallOutlinesSize;

///Page stats
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDebugDocRejection;

///Dont Suspect dict wds longer than this
///@param Type INT
///@param Default 2
extern NSString *const kG8SuspectShortWords;

///Adaptation decision algorithm for tess
///@param Type INT
///@param Default 3
extern NSString *const kG8TesseditTestAdaptionMode;

///Test adaption criteria
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditTestAdaption;

///Reestimate debug
///@param Type INT
///@param Default 0
extern NSString *const kG8DebugXHtLevel;

///Dont bother with word plausibility
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditUnrejAnyWd;

///Non standard number of outlines
///@param Type STRING
///@param Default "%| "
extern NSString *const kG8OutlinesOdd;

///Il1 conflict set
///@param Type STRING
///@param Default "Il1[]"
extern NSString *const kG8ConflictSetIL1;

///Rejection algorithm
///@param Type INT
///@param Default 0
extern NSString *const kG8TesseditRejectMode;

///How many non-noise blbs either side?
///@param Type INT
///@param Default 1
extern NSString *const kG8FixspNonNoiseLimit;

///Print paragraph debug info.
///@param Type INT
///@param Default 0
extern NSString *const kG8ParagraphDebugLevel;

///Dump char choices
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDumpChoices;

///Non standard number of outlines
///@param Type STRING
///@param Default "ij!?%\":;"
extern NSString *const kG8Outlines2;

///Use word segmentation quality metric
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDontBlkrejGoodWds;

///Use acceptability in okstring
///@param Type BOOL
///@param Default true
extern NSString *const kG8CrunchAcceptOk;

///Test for point
///@param Type BOOL
///@param Default false
extern NSString *const kG8TestPt;

///Take segmentation and labeling from box file
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditResegmentFromBoxes;

///Small if lt xht x this
///@param Type double
///@param Default 0.6
extern NSString *const kG8CrunchSmallOutlinesSize;

///Check/Correct x-height
///@param Type BOOL
///@param Default true
extern NSString *const kG8TesseditRedoXheight;

///Maximum top of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a subscript.
///@param Type double
///@param Default 0.5
extern NSString *const kG8SubscriptMaxYTop;

///Individual rejection control
///@param Type BOOL
///@param Default true
extern NSString *const kG8RejUseTessAccepted;

///Draw output words
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditDisplayOutwords;

///Call Tess to learn blobs
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditTrainingTess;

///Adaption debug
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditRejectionDebug;

///Use DOC dawg in 11l conf. detector
///@param Type BOOL
///@param Default false
extern NSString *const kG8RejTrustDocDawg;

///Use CJK fixed pitch model
///@param Type BOOL
///@param Default FALSE
extern NSString *const kG8TextordUseCjkFpModel;

///Dont reject ANYTHING
///@param Type BOOL
///@param Default false
extern NSString *const kG8TesseditZeroRejection;

///Leading punctuation
///@param Type STRING
///@param Default "('`\""
extern NSString *const kG8ChsLeadingPunct;

///Del if word width lt xht x this
///@param Type double
///@param Default 3.0
extern NSString *const kG8CrunchDelMinWidth;

///Amount of debug output for bigram correction.
///@param Type INT
///@param Default 0
extern NSString *const kG8TesseditBigramDebug;

///Filename extension
///@param Type STRING
///@param Default ".tif"
extern NSString *const kG8FileType;

///Whitelist of chars to recognize
///@param Type STRING
///@param Default ""
extern NSString *const kG8TesseditCharWhitelist;

///Crunch words with long repetitions
///@param Type INT
///@param Default 3
extern NSString *const kG8CrunchLongRepetitions;

///max char width-to-height ratio allowed in segmentation
///@param Type double
///@param Default 2.0
extern NSString *const kG8HeuristicMaxCharWhRatio DEPRECATED_ATTRIBUTE;

///Multiplying factor of current best rate to prune other hypotheses
///@param Type double
///@param Default 2.0
extern NSString *const kG8BestratePruningFactor DEPRECATED_ATTRIBUTE;

///Turn on character type (property) consistency permuter
///@param Type BOOL
///@param Default 0
extern NSString *const kG8PermuteChartypeWord DEPRECATED_ATTRIBUTE;

///Enable new segmentation search path.
///@param Type BOOL
///@param Default false
extern NSString *const kG8EnableNewSegsearch DEPRECATED_ATTRIBUTE;

///use new state cost heuristics for segmentation state evaluation
///@param Type BOOL
///@param Default FALSE
extern NSString *const kG8UseNewStateCost DEPRECATED_ATTRIBUTE;

///char permutation debug
///@param Type BOOL
///@param Default 0
extern NSString *const kG8PermuteDebug DEPRECATED_ATTRIBUTE;

///Score multipler for script consistency within a word. Being a 'reward' factor, it should be <= 1. Smaller value implies bigger reward.
///@param Type double
///@param Default 0.95
extern NSString *const kG8SegmentRewardScript DEPRECATED_ATTRIBUTE;

///Debug the whole segmentation process
///@param Type INT
///@param Default 0
extern NSString *const kG8SegmentDebug DEPRECATED_ATTRIBUTE;

///Score multipler for ngram permuter's best choice (only used in the Han script path).
///@param Type double
///@param Default 0.99
extern NSString *const kG8SegmentRewardNgramBestChoice DEPRECATED_ATTRIBUTE;

///Turn on word script consistency permuter
///@param Type BOOL
///@param Default 0
extern NSString *const kG8PermuteScriptWord DEPRECATED_ATTRIBUTE;

///Turn on fixed-length phrasebook search permuter
///@param Type BOOL
///@param Default 0
extern NSString *const kG8PermuteFixedLengthDawg DEPRECATED_ATTRIBUTE;

///weight associated with char rating in combined cost of state
///@param Type double
///@param Default 1
extern NSString *const kG8HeuristicWeightRating DEPRECATED_ATTRIBUTE;

///Run only the top choice permuter
///@param Type BOOL
///@param Default false
extern NSString *const kG8PermuteOnlyTop DEPRECATED_ATTRIBUTE;

///base factor for adding segmentation cost into word rating. It's a multiplying factor, the larger the value above 1, the bigger the effect of segmentation cost.
///@param Type double
///@param Default 1.25
extern NSString *const kG8HeuristicSegcostRatingBase DEPRECATED_ATTRIBUTE;

///weight associated with width evidence in combined cost of state
///@param Type double
///@param Default 1000.0
extern NSString *const kG8HeuristicWeightWidth DEPRECATED_ATTRIBUTE;

///Activate character-level n-gram-based permuter
///@param Type BOOL
///@param Default false
extern NSString *const kG8NgramPermuterActivated DEPRECATED_ATTRIBUTE;

///Load fixed length dawgs (e.g. for non-space delimited languages)
///@param Type BOOL
///@param Default true
extern NSString *const kG8LoadFixedLengthDawgs DEPRECATED_ATTRIBUTE;

///Maximum character width-to-height ratio for fixed pitch fonts
///@param Type double
///@param Default 2.0
extern NSString *const kG8SegsearchMaxFixedPitchCharWhRatio DEPRECATED_ATTRIBUTE;

///incorporate segmentation cost in word rating?
///@param Type BOOL
///@param Default 0
extern NSString *const kG8SegmentSegcostRating DEPRECATED_ATTRIBUTE;

///weight associated with seam cut in combined cost of state
///@param Type double
///@param Default 0
extern NSString *const kG8HeuristicWeightSeamcut DEPRECATED_ATTRIBUTE;

///Score multipler for char type consistency within a word.
///@param Type double
///@param Default 0.97
extern NSString *const kG8SegmentRewardChartype DEPRECATED_ATTRIBUTE;

///Depth of blob choice lists to explore when fixed length dawgs are on
///@param Type INT
///@param Default 3
extern NSString *const kG8LanguageModelFixedLengthChoicesDepth DEPRECATED_ATTRIBUTE;

///Acceptance decision algorithm
///@param Type INT
///@param Default 5
extern NSString *const kG8TesseditOkMode DEPRECATED_ATTRIBUTE;

#endif
