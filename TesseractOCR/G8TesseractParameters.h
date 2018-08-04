//
//  G8TesseractParameters.h
//  Tesseract OCR iOS
//  This code is auto-generated from Tesseract headers.
//
//  Created by Nikolay Volosatov on 04/08/18.
//  Copyright (c) 2018 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Tesseract_OCR_iOS_G8TesseractParameters_h
#define Tesseract_OCR_iOS_G8TesseractParameters_h

///Expect spaces bigger than this
///@brief Type double Default 0.33
extern NSString *const kG8ParamTospTableXhtSpRatio;

///Generate training data from boxed chars
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditTrainFromBoxes;

///* blob height for initial linesize
///@brief Type double Default 1.25
extern NSString *const kG8ParamTextordMinLinesize;

///Fract of xheight for wide
///@brief Type double Default 0.52
extern NSString *const kG8ParamTospWideFraction;

///Use spline baseline
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordFixXheightBug;

///Good blob limit
///@brief Type double Default -2.25
extern NSString *const kG8ParamTesseditCertaintyThreshold;

///Penalty increment
///@brief Type double Default 0.01
extern NSString *const kG8ParamLanguageModelPenaltyIncrement;

///Learn both character fragments (as is done in the special low exposure mode) as well as unfragmented characters.
///@brief Type BOOL Default false
extern NSString *const kG8ParamApplyboxLearnCharsAndCharFragsMode;

///Generate more boxes from boxed chars
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditMakeBoxesFromBoxes;

///How wide fuzzies need context
///@brief Type double Default 0.75
extern NSString *const kG8ParamTospPassWideFuzzSpToContext;

///Use pre-adapted classifier templates
///@brief Type BOOL Default 0
extern NSString *const kG8ParamClassifyUsePreAdaptedTemplates;

///Split overlap adjustment
///@brief Type double Default 0.9
extern NSString *const kG8ParamChopOverlapKnob;

///Extend permuter check
///@brief Type BOOL Default false
extern NSString *const kG8ParamRejAlphasInNumberPerm;

///Baseline Normalized Matching
///@brief Type BOOL Default 0
extern NSString *const kG8ParamTessBnMatching;

///Don't bother with word plausibility
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditUnrejAnyWd;

///Dump word pass/fail chk
///@brief Type BOOL Default false
extern NSString *const kG8ParamDebugAcceptableWds;

///Debug data
///@brief Type INT Default 0
extern NSString *const kG8ParamTospDebugLevel;

///Use information from fragments to guide chopping process
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamFragmentsGuideChopper;

///Factor to expand rows by in expand_rows
///@brief Type double Default 1.0
extern NSString *const kG8ParamTextordExpansionFactor;

///Use ratings matrix/beam searct with lstm
///@brief Type BOOL Default 1
extern NSString *const kG8ParamLstmUseMatrix;

///Write repetition char code
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditWriteRepCodes;

///Load unambiguous word dawg.
///@brief Type BOOL Default true
extern NSString *const kG8ParamLoadUnambigDawg;

///Take segmentation and labeling from box file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditResegmentFromBoxes;

///Min # of permanent classes
///@brief Type INT Default 1
extern NSString *const kG8ParamMatcherPermanentClassesMin;

///POTENTIAL crunch rating lt this
///@brief Type double Default 60
extern NSString *const kG8ParamCrunchDelRating;

///Default flip
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospFlipFuzzKnToSp;

///Score multiplier for word matches which have good case and are frequent in the given language (lower is better).
///@brief Type double Default 1.0
extern NSString *const kG8ParamSegmentPenaltyDictFrequentWord;

///Factor to bring log-probs into the same range as ratings when multiplied by outline length
///@brief Type double Default 16.0
extern NSString *const kG8ParamLanguageModelNgramRatingFactor;

///rep gap multiplier for space
///@brief Type double Default 1.6
extern NSString *const kG8ParamTospRepSpace;

///or should we use mean
///@brief Type INT Default 3
extern NSString *const kG8ParamTospEnoughSpaceSamplesForMedian;

///Min Number of Points on Outline
///@brief Type INT Default 6
extern NSString *const kG8ParamChopMinOutlinePoints;

///Max large speckle size
///@brief Type double Default 0.30
extern NSString *const kG8ParamSpeckleLargeMaxSize;

///Which OCR engine(s) to run (Tesseract, LSTM, both). Defaults to loading and running the most accurate available.
///@brief Type INT Default tesseract::OEM_DEFAULT
extern NSString *const kG8ParamTesseditOcrEngineMode;

///Output text with boxes
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditCreateBoxfile;

///How many times worse certainty does a superscript position glyph need to be for us to try classifying it as a char with a different baseline?
///@brief Type double Default 2.0
extern NSString *const kG8ParamSuperscriptWorseCertainty;

///Maximum size of viterbi list.
///@brief Type INT Default 10
extern NSString *const kG8ParamMaxViterbiListSize;

///Good split limit
///@brief Type double Default 50.0
extern NSString *const kG8ParamChopGoodSplit;

///Individual rejection control
///@brief Type BOOL Default true
extern NSString *const kG8ParamRejUseTessBlanks;

///Blacklist of chars not to recognize
///@brief Type STRING Default ""
extern NSString *const kG8ParamTesseditCharBlacklist;

///Min blobs before gradient counted
///@brief Type INT Default 4
extern NSString *const kG8ParamTextordMinBlobsInRow;

///coord of test pt
///@brief Type INT Default -INT32_MAX
extern NSString *const kG8ParamTextordTestY;

///coord of test pt
///@brief Type INT Default -INT32_MAX
extern NSString *const kG8ParamTextordTestX;

///A suffix of user-provided patterns located in tessdata.
///@brief Type STRING Default ""
extern NSString *const kG8ParamUserPatternsSuffix;

///Use within xht gap for wd breaks
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospUseXhtGaps;

///Conversion of word/line box file to char box file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditResegmentFromLineBoxes;

///Mark v.bad words for tilde crunch
///@brief Type BOOL Default true
extern NSString *const kG8ParamUnlvTildeCrunching;

///SegSearch debug level
///@brief Type INT Default 0
extern NSString *const kG8ParamSegsearchDebugLevel;

///Load dawg with number patterns.
///@brief Type BOOL Default true
extern NSString *const kG8ParamLoadNumberDawg;

///Worst certainty for words that can be inserted into the document dictionary
///@brief Type double Default -2.25
extern NSString *const kG8ParamDocDictCertaintyThreshold;

///Min blobs in each spline segment
///@brief Type INT Default 8
extern NSString *const kG8ParamTextordSplineMinblobs;

///POTENTIAL crunch rating lt this
///@brief Type double Default 40
extern NSString *const kG8ParamCrunchPotPoorRate;

///Test xheight algorithms
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordDebugXheights;

///Suspect marker level
///@brief Type INT Default 99
extern NSString *const kG8ParamSuspectLevel;

///Print multilang debug info.
///@brief Type INT Default 0
extern NSString *const kG8ParamMultilangDebugLevel;

///crunch garbage rating lt this
///@brief Type double Default 60
extern NSString *const kG8ParamCrunchPoorGarbageRate;

///Threshold for new punc char certainty
///@brief Type double Default -2.5
extern NSString *const kG8ParamNoiseCertPunc;

///Add words to the document dictionary
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditEnableDocDict;

///Display unsorted blobs
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordShowBlobs;

///Accepted variation
///@brief Type double Default 0.1
extern NSString *const kG8ParamTextordXheightErrorMargin;

///Save adapted templates to a file
///@brief Type BOOL Default 0
extern NSString *const kG8ParamClassifySaveAdaptedTemplates;

///Allow NN to unrej
///@brief Type STRING Default "-?*\075"
extern NSString *const kG8ParamOkRepeatedChNonAlphanumWds;

///Maximum number of prunable (those for which PrunablePath() is true) entries in each viterbi list recorded in BLOB_CHOICEs
///@brief Type INT Default 10
extern NSString *const kG8ParamLanguageModelViterbiListMaxNumPrunable;

///Don't crunch words with long lower case strings
///@brief Type INT Default 4
extern NSString *const kG8ParamCrunchLeaveUcStrings;

///Strength of the character ngram model relative to the character classifier
///@brief Type double Default 0.03
extern NSString *const kG8ParamLanguageModelNgramScaleFactor;

///xh fract width error for norm blobs
///@brief Type double Default 0.4
extern NSString *const kG8ParamTextordNoiseSxfract;

///Max number of seams in seam_pile
///@brief Type INT Default 150
extern NSString *const kG8ParamChopSeamPileSize;

///Perform training for ambiguities
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditAmbigsTraining;

///Block stats to use fixed pitch rows?
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospOnlyUsePropRows;

///Print paragraph debug info.
///@brief Type INT Default 0
extern NSString *const kG8ParamParagraphDebugLevel;

///good_quality_doc lte outline error limit
///@brief Type double Default 1.0
extern NSString *const kG8ParamQualityOutlinePc;

///Don't touch bad rating limit
///@brief Type double Default 999.9
extern NSString *const kG8ParamSuspectRatingPerCh;

///Print blamer debug messages
///@brief Type BOOL Default false
extern NSString *const kG8ParamWordrecDebugBlamer;

///Rejection algorithm
///@brief Type INT Default 0
extern NSString *const kG8ParamTesseditRejectMode;

///crunch rating lt this
///@brief Type double Default 80.0
extern NSString *const kG8ParamCrunchTerribleRating;

///Certainty threshold for non-dict words
///@brief Type double Default -2.50
extern NSString *const kG8ParamStopperNondictCertaintyBase;

///Default score multiplier for word matches, which may have case issues (lower is better).
///@brief Type double Default 1.3125
extern NSString *const kG8ParamSegmentPenaltyDictCaseBad;

///Apply row rejection to good docs
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditRowRejGoodDocs;

///Display blob bounds after pre-ass
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordShowFinalBlobs;

///Average classifier score of a non-matching unichar
///@brief Type double Default -40.0
extern NSString *const kG8ParamLanguageModelNgramNonmatchScore;

///Language model debug level
///@brief Type INT Default 0
extern NSString *const kG8ParamLanguageModelDebugLevel;

///good_quality_doc gte good char limit
///@brief Type double Default 1.1
extern NSString *const kG8ParamQualityRowrejPc;

///Maximum number of pain point classifications per word.
///@brief Type INT Default 10
extern NSString *const kG8ParamSegsearchMaxFutileClassifications;

///Remove and conditionally reassign small outlines when they confuse layout analysis, determining diacritics vs noise
///@brief Type BOOL Default true
extern NSString *const kG8ParamEnableNoiseRemoval;

///Del if word gt xht x this below bl
///@brief Type double Default 0.5
extern NSString *const kG8ParamCrunchDelLowWord;

///Penalty for inconsistent script
///@brief Type double Default 0.5
extern NSString *const kG8ParamLanguageModelPenaltyScript;

///Exclude fragments that do not match any whole character with at least this certainty
///@brief Type double Default -3.0
extern NSString *const kG8ParamClassifyCharacterFragmentsGarbageCertaintyThreshold;

///Class Pruner CutoffStrength:
///@brief Type INT Default 7
extern NSString *const kG8ParamClassifyCpCutoffStrength;

///Only rej partially rejected words in block rejection
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditPreserveBlkRejPerfectWds;

///Page separator (default is form feed control character)
///@brief Type STRING Default "\f"
extern NSString *const kG8ParamPageSeparator;

///Aspect ratio dot/hyphen test
///@brief Type double Default 1.8
extern NSString *const kG8ParamTesseditUpperFlipHyphen;

///OK split limit
///@brief Type double Default 100.0
extern NSString *const kG8ParamChopOkSplit;

///For smooth factor
///@brief Type INT Default 4
extern NSString *const kG8ParamTextordSkewsmoothOffset;

///Score penalty (0.1 = 10%) added if an xheight is inconsistent.
///@brief Type double Default 0.25
extern NSString *const kG8ParamXheightPenaltyInconsistent;

///Chop debug
///@brief Type INT Default 0
extern NSString *const kG8ParamChopDebug;

///Reject noise-like words
///@brief Type BOOL Default true
extern NSString *const kG8ParamTextordNoiseRejwords;

///Debug character fragments
///@brief Type INT Default 0
extern NSString *const kG8ParamFragmentsDebug;

///Dot to norm ratio for deletion
///@brief Type double Default 6.0
extern NSString *const kG8ParamTextordNoiseRowratio;

///X / Y  length weight
///@brief Type INT Default 3
extern NSString *const kG8ParamChopXYWeight;

///Max allowed deviation of blob top outside of font data
///@brief Type INT Default 8
extern NSString *const kG8ParamXHtAcceptanceTolerance;

///Maximum number of different character choices to consider during permutation. This limit is especially useful when user patterns are specified, since overly generic patterns can result in dawg search exploring an overly large number of options.
///@brief Type INT Default 10000
extern NSString *const kG8ParamMaxPermuterAttempts;

///Use sigmoidal score for certainty
///@brief Type BOOL Default false
extern NSString *const kG8ParamLanguageModelUseSigmoidalCertainty;

///Force straight baselines
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordStraightBaselines;

///Reestimate debug
///@brief Type INT Default 0
extern NSString *const kG8ParamDebugXHtLevel;

///Don't pot crunch sensible strings
///@brief Type BOOL Default false
extern NSString *const kG8ParamCrunchLeaveAcceptStrings;

///Generate and print debug information for adaption
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditAdaptionDebug;

///Output data to debug file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDebugQualityMetrics;

///Only stat OBVIOUS spaces
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospBlockUseCertSpaces;

///Only reject tess failures
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditMinimalRejection;

///Del if word ht lt xht x this
///@brief Type double Default 0.7
extern NSString *const kG8ParamCrunchDelMinHt;

///gap ratio to flip sp->kern
///@brief Type double Default 0.83
extern NSString *const kG8ParamTospGapFactor;

///Prevent multiple baselines
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordFixMakerowBug;

///Only run OCR for words that had truth recorded in BlamerBundle
///@brief Type BOOL Default false
extern NSString *const kG8ParamWordrecSkipNoTruthWords;

///Height fraction to discard outlines as speckle noise
///@brief Type double Default 1.0/64
extern NSString *const kG8ParamTextordNoiseHfract;

///xh fract error for norm blobs
///@brief Type double Default 0.2
extern NSString *const kG8ParamTextordNoiseSyfract;

///Penalty for inconsistent spacing
///@brief Type double Default 0.05
extern NSString *const kG8ParamLanguageModelPenaltySpacing;

///Debug level for sub & superscript fixer
///@brief Type INT Default 0
extern NSString *const kG8ParamSuperscriptDebug;

///Don't output block information
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamWordrecNoBlock;

///Lag for skew on row accumulation
///@brief Type double Default 0.02
extern NSString *const kG8ParamTextordSkewLag;

///Max diacritics to apply to a blob
///@brief Type INT Default 8
extern NSString *const kG8ParamNoiseMaxperblob;

///Vertical creep
///@brief Type BOOL Default 0
extern NSString *const kG8ParamChopVerticalCreep;

///Min suspect level for rejecting spaces
///@brief Type INT Default 100
extern NSString *const kG8ParamSuspectSpaceLevel;

///Min char x-norm scale ...
///@brief Type double Default 0.0
extern NSString *const kG8ParamClassifyMinNormScaleX;

///Write .pdf output file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditCreatePdf;

///Penalty for inconsistent font
///@brief Type double Default 0.00
extern NSString *const kG8ParamLanguageModelPenaltyFont;

///Page number to apply boxes from
///@brief Type INT Default 0
extern NSString *const kG8ParamApplyboxPage;

///Classify debug level
///@brief Type INT Default 0
extern NSString *const kG8ParamClassifyDebugLevel;

///Use only the first UTF8 step of the given string when computing log probabilities.
///@brief Type BOOL Default false
extern NSString *const kG8ParamUseOnlyFirstUft8Step;

///rej good doc wd if more than this fraction rejected
///@brief Type double Default 1.1
extern NSString *const kG8ParamTesseditGoodDocStillRowrejWd;

///Use DOC dawg in 11l conf. detector
///@brief Type BOOL Default false
extern NSString *const kG8ParamRejTrustDocDawg;

///Only stat OBVIOUS spaces
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospRowUseCertSpaces1;

///No.samples reqd to reestimate for row
///@brief Type INT Default 10
extern NSString *const kG8ParamTospRedoKernLimit;

///Del if word ht gt xht x this
///@brief Type double Default 3.0
extern NSString *const kG8ParamCrunchDelMaxHt;

///Veto ratio between classifier ratings
///@brief Type double Default 1.5
extern NSString *const kG8ParamClassifyMaxRatingRatio;

///Min cap/xheight
///@brief Type double Default 1.25
extern NSString *const kG8ParamTextordAscxRatioMin;

///Output char for unidentified blobs
///@brief Type STRING Default "|"
extern NSString *const kG8ParamUnrecognisedChar;

///Del if word width lt xht x this
///@brief Type double Default 3.0
extern NSString *const kG8ParamCrunchDelMinWidth;

///Min difference of kn & sp in table
///@brief Type double Default 2.25
extern NSString *const kG8ParamTospTableKnSpRatio;

///Min pile height to make ascheight
///@brief Type double Default 0.08
extern NSString *const kG8ParamTextordAscheightModeFraction;

///Allows to include glyph confidences in the hOCR output
///@brief Type BOOL Default false
extern NSString *const kG8ParamGlyphConfidences;

///A superscript scaled down more than this is unbelievably small.  For example, 0.3 means we expect the font size to be no smaller than 30% of the text line font size.
///@brief Type double Default 0.4
extern NSString *const kG8ParamSuperscriptScaledownRatio;

///wide if w/h less than this
///@brief Type double Default 0.0
extern NSString *const kG8ParamTospWideAspectRatio;

///Don't trust spaces less than this time kn
///@brief Type double Default 1.5
extern NSString *const kG8ParamTospMinSaneKnSp;

///Fract of xheight for fuzz sp
///@brief Type double Default 0.6
extern NSString *const kG8ParamTospFuzzySpaceFactor;

///Scale factor for features not used
///@brief Type double Default 0.00390625
extern NSString *const kG8ParamTesseditClassMissScale;

///POTENTIAL crunch cert lt this
///@brief Type double Default -10.0
extern NSString *const kG8ParamCrunchDelCert;

///Lengths of unichars in word_to_debug
///@brief Type STRING Default ""
extern NSString *const kG8ParamWordToDebugLengths;

///Min pile height to make descheight
///@brief Type double Default 0.08
extern NSString *const kG8ParamTextordDescheightModeFraction;

///Capture the image from the IPE
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditWriteImages;

///Run in parallel where possible
///@brief Type INT Default 0
extern NSString *const kG8ParamTesseditParallelize;

///Certainty to add for each dict char above small word size.
///@brief Type double Default -0.50
extern NSString *const kG8ParamStopperCertaintyPerChar;

///Test for point
///@brief Type BOOL Default false
extern NSString *const kG8ParamTestPt;

///Words are delimited by space
///@brief Type BOOL Default true
extern NSString *const kG8ParamLanguageModelNgramSpaceDelimitedLanguage;

///For adj length in rating per ch
///@brief Type INT Default 10
extern NSString *const kG8ParamCrunchRatingMax;

///Penalty for inconsistent case
///@brief Type double Default 0.1
extern NSString *const kG8ParamLanguageModelPenaltyCase;

///Fract of kerns reqd for isolated row stats
///@brief Type double Default 0.65
extern NSString *const kG8ParamTospEnoughSmallGaps;

///Accept good rating limit
///@brief Type double Default -999.9
extern NSString *const kG8ParamSuspectAcceptRating;

///Veto difference between classifier certainties
///@brief Type double Default 5.5
extern NSString *const kG8ParamClassifyMaxCertaintyMargin;

///Class Pruner Multiplier 0-255:
///@brief Type INT Default 15
extern NSString *const kG8ParamClassifyClassPrunerMultiplier;

///Individual rejection control
///@brief Type BOOL Default true
extern NSString *const kG8ParamRejUseGoodPerm;

///Don't adapt to i/I at beginning of word
///@brief Type INT Default 0
extern NSString *const kG8ParamIl1AdaptionTest;

///Min change in xht before actually trying it
///@brief Type INT Default 8
extern NSString *const kG8ParamXHtMinChange;

///POTENTIAL crunch garbage
///@brief Type BOOL Default true
extern NSString *const kG8ParamCrunchPotGarbage;

///Max words to keep in list
///@brief Type INT Default 10
extern NSString *const kG8ParamTesseditTruncateWordchoiceLog;

///Enable adaptive classifier
///@brief Type BOOL Default 1
extern NSString *const kG8ParamClassifyEnableAdaptiveMatcher;

///Write .html hOCR output file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditCreateHocr;

///Certainty scaling factor
///@brief Type double Default 20.0
extern NSString *const kG8ParamCertaintyScale;

///Size of dict word to be treated as non-dict word
///@brief Type INT Default 2
extern NSString *const kG8ParamStopperSmallwordSize;

///Max number of broken pieces to associate
///@brief Type INT Default 4
extern NSString *const kG8ParamWordrecMaxJoinChunks;

///Dot to norm ratio for deletion
///@brief Type double Default 2.0
extern NSString *const kG8ParamTextordNoiseNormratio;

///Split length adjustment
///@brief Type double Default 0.5
extern NSString *const kG8ParamChopSplitDistKnob;

///Debug level for hyphenated words.
///@brief Type INT Default 0
extern NSString *const kG8ParamHyphenDebugLevel;

///Write .unlv output file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditWriteUnlv;

///good_quality_doc gte good blobs limit
///@brief Type double Default 0.0
extern NSString *const kG8ParamQualityBlobPc;

///A filename of user-provided words.
///@brief Type STRING Default ""
extern NSString *const kG8ParamUserWordsFile;

///Fract of xheight for fuzz sp
///@brief Type double Default 0.5
extern NSString *const kG8ParamTospFuzzySpaceFactor1;

///Fract of xheight for fuzz sp
///@brief Type double Default 0.72
extern NSString *const kG8ParamTospFuzzySpaceFactor2;

///Write .txt output file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditCreateTxt;

///Run interactively?
///@brief Type BOOL Default false
extern NSString *const kG8ParamInteractiveDisplayMode;

///Fraction of size for maxima
///@brief Type INT Default 10
extern NSString *const kG8ParamTextordNoiseSizefraction;

///Write block separators in output
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditWriteBlockSeparators;

///Adaptation decision algorithm for tess
///@brief Type INT Default 3
extern NSString *const kG8ParamTesseditTestAdaptionMode;

///Allow feature extractors to see the original outline
///@brief Type BOOL Default false
extern NSString *const kG8ParamPolyAllowDetailedFx;

///Space stats use prechopping?
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospUsePreChopping;

///narrow if w/h less than this
///@brief Type double Default 0.48
extern NSString *const kG8ParamTospNarrowAspectRatio;

///Display page correlated rows
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordShowParallelRows;

///Write .tsv output file
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditCreateTsv;

///Percentile for small blobs
///@brief Type double Default 20
extern NSString *const kG8ParamTextordBlobSizeSmallile;

///As it says
///@brief Type INT Default 0
extern NSString *const kG8ParamCrunchDebug;

///Enable match debugger
///@brief Type BOOL Default 0
extern NSString *const kG8ParamClassifyEnableAdaptiveDebugger;

///Crunch words with long repetitions
///@brief Type INT Default 3
extern NSString *const kG8ParamCrunchLongRepetitions;

///Penalty for inconsistent character type
///@brief Type double Default 0.3
extern NSString *const kG8ParamLanguageModelPenaltyChartype;

///Perfect Match (0-1)
///@brief Type double Default 0.02
extern NSString *const kG8ParamMatcherPerfectThreshold;

///Penalty for words not in the frequent word dictionary
///@brief Type double Default 0.1
extern NSString *const kG8ParamLanguageModelPenaltyNonFreqDictWord;

///Vigorously remove noise
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordHeavyNr;

///how far between kern and space?
///@brief Type double Default 0
extern NSString *const kG8ParamTospThresholdBias2;

///how far between kern and space?
///@brief Type double Default 0
extern NSString *const kG8ParamTospThresholdBias1;

///Force parallel baselines
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordParallelBaselines;

///%rej allowed before rej whole row
///@brief Type double Default 40.00
extern NSString *const kG8ParamTesseditRejectRowPercent;

///Threshold for good features during adaptive 0-255
///@brief Type INT Default 230
extern NSString *const kG8ParamClassifyAdaptFeatureThreshold;

///Enable vertical detection
///@brief Type BOOL Default true
extern NSString *const kG8ParamTextordTabfindVerticalText;

///Enable single word correction based on the dictionary.
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditEnableDictCorrection;

///Width change adjustment
///@brief Type double Default 5.0
extern NSString *const kG8ParamChopWidthChangeKnob;

///Don't reject ANYTHING AT ALL
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditZeroKelvinRejection;

///Pixel size of noise
///@brief Type INT Default 7
extern NSString *const kG8ParamTextordMaxNoiseSize;

///Fract of xheight for narrow
///@brief Type double Default 0.3
extern NSString *const kG8ParamTospNarrowFraction;

///xcoord
///@brief Type double Default 99999.99
extern NSString *const kG8ParamTestPtX;

///Reduce rejection on good docs
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditGoodQualityUnrej;

///Learning Debug Level:
///@brief Type INT Default 0
extern NSString *const kG8ParamClassifyLearningDebugLevel;

///Max width of blobs to make rows
///@brief Type double Default 8
extern NSString *const kG8ParamTextordWidthLimit;

///xht multiplier
///@brief Type double Default -1
extern NSString *const kG8ParamTospIgnoreBigGaps;

///Load system word dawg.
///@brief Type BOOL Default true
extern NSString *const kG8ParamLoadSystemDawg;

///Only stat OBVIOUS spaces
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospNarrowBlobsNotCert;

///Turn on/off the use of character ngram model
///@brief Type BOOL Default false
extern NSString *const kG8ParamLanguageModelNgramOn;

///Try to set the blame for errors
///@brief Type BOOL Default false
extern NSString *const kG8ParamWordrecRunBlamer;

///Fuzzy if less than this
///@brief Type double Default 3.0
extern NSString *const kG8ParamTospTableFuzzyKnSpRatio;

///Don't remove noise blobs
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordNoRejects;

///Rej blbs near image edge limit
///@brief Type INT Default 2
extern NSString *const kG8ParamTesseditImageBorder;

///Pass ANY flip to context?
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospAllFlipsFuzzy;

///super norm blobs to save row
///@brief Type INT Default 1
extern NSString *const kG8ParamTextordNoiseSncount;

///Contextual fixspace debug
///@brief Type INT Default 0
extern NSString *const kG8ParamDebugFixSpaceLevel;

///Use dictword test
///@brief Type BOOL Default false
extern NSString *const kG8ParamRej1IlUseDictWord;

///Debug row garbage detector
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordNoiseDebug;

///Don't use any alphabetic-specific tricks. Set to true in the traineddata config file for scripts that are cursive or inherently fixed-pitch
///@brief Type BOOL Default false
extern NSString *const kG8ParamSegmentNonalphabeticScript;

///Space stats use prechopping?
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospOldToMethod;

///Print timing stats
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditTimingDebug;

///Prioritize blob division over chopping
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamPrioritizeDivision;

///Hingepoint for disjoint certainty
///@brief Type double Default -2.5
extern NSString *const kG8ParamNoiseCertDisjoint;

///POTENTIAL crunch cert lt this
///@brief Type double Default -8.0
extern NSString *const kG8ParamCrunchPotPoorCert;

///Score multiplier for glyph fragment segmentations which do not match a dictionary word (lower is better).
///@brief Type double Default 1.25
extern NSString *const kG8ParamSegmentPenaltyDictNonword;

///crunch garbage cert lt this
///@brief Type double Default -9.0
extern NSString *const kG8ParamCrunchPoorGarbageCert;

///Fraction of neighbourhood
///@brief Type double Default 0.4
extern NSString *const kG8ParamTextordOccupancyThreshold;

///Script has no xheight, so use a single mode for horizontal text
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordSingleHeightMode;

///How many potential indicators needed
///@brief Type INT Default 1
extern NSString *const kG8ParamCrunchPotIndicators;

///Min size of baseline shift
///@brief Type double Default 9.99
extern NSString *const kG8ParamTextordBlshiftXfraction;

///Constrain relative values of inter and intra-word gaps for old_to_method.
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospOldToConstrainSpKn;

///Break input into lines and remap boxes if present
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditTrainLineRecognizer;

///Rating scaling factor
///@brief Type double Default 1.5
extern NSString *const kG8ParamRatingScale;

///Fraction of line spacing for quad
///@brief Type double Default 0.02
extern NSString *const kG8ParamTextordSplineShiftFraction;

///Max desc/xheight
///@brief Type double Default 0.6
extern NSString *const kG8ParamTextordDescxRatioMax;

///Force all rep chars the same
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditConsistentReps;

///Don't let sp minus kn get too small
///@brief Type double Default 0.2
extern NSString *const kG8ParamTospSillyKnSpGap;

///Penalty for non-dictionary words
///@brief Type double Default 0.15
extern NSString *const kG8ParamLanguageModelPenaltyNonDictWord;

///Max width before chopping
///@brief Type double Default 1.5
extern NSString *const kG8ParamTextordChopWidth;

///Fraction of linespace for good overlap
///@brief Type double Default 0.375
extern NSString *const kG8ParamTextordOverlapX;

///Make output have exactly one word per WERD
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditWordForWord;

///Segmentation adjustment debug
///@brief Type INT Default 0
extern NSString *const kG8ParamSegmentAdjustDebug;

///Min pile height to make xheight
///@brief Type double Default 0.4
extern NSString *const kG8ParamTextordXheightModeFraction;

///In multilingual mode use params model of the primary language
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditUsePrimaryParamsModel;

///How many non-noise blbs either side?
///@brief Type INT Default 1
extern NSString *const kG8ParamFixspNonNoiseLimit;

///Minimum bottom of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a superscript.
///@brief Type double Default 0.3
extern NSString *const kG8ParamSuperscriptMinYBottom;

///Maximum size of viterbi lists recorded in BLOB_CHOICEs
///@brief Type INT Default 500
extern NSString *const kG8ParamLanguageModelViterbiListMaxSize;

///Fraction of height used as a minimum gap for aligned blobs.
///@brief Type double Default 0.75
extern NSString *const kG8ParamTextordTabfindAlignedGapFraction;

///Fraction of line spacing for outlier
///@brief Type double Default 0.1
extern NSString *const kG8ParamTextordSplineOutlierFraction;

///Use within xht gap for wd breaks
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospStatsUseXhtGaps;

///Normalization Method   ...
///@brief Type INT Default character
extern NSString *const kG8ParamClassifyNormMethod;

///Min acceptable orientation margin
///@brief Type double Default 7.0
extern NSString *const kG8ParamMinOrientationMargin;

///Only initialize with the config file. Useful if the instance is not going to be used for OCR but say only for layout analysis.
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditInitConfigOnly;

///Preserve multiple interword spaces
///@brief Type BOOL Default false
extern NSString *const kG8ParamPreserveInterwordSpaces;

///Only rej partially rejected words in row rejection
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditPreserveRowRejPerfectWds;

///New template margin (0-1)
///@brief Type double Default 0.1
extern NSString *const kG8ParamMatcherRatingMargin;

///Do not include character fragments in the results of the classifier
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamDisableCharacterFragments;

///Maximum top of a character measured as a multiple of x-height above the baseline for us to reconsider whether it's a subscript.
///@brief Type double Default 0.5
extern NSString *const kG8ParamSubscriptMaxYTop;

///Merge the fragments in the ratings matrix and delete them after merging
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamMergeFragmentsInMatrix;

///unrej potential with no checks
///@brief Type BOOL Default false
extern NSString *const kG8ParamBlandUnrej;

///Del if word gt xht x this above bl
///@brief Type double Default 1.5
extern NSString *const kG8ParamCrunchDelHighWord;

///Debug reassignment of small outlines
///@brief Type INT Default 0
extern NSString *const kG8ParamDebugNoiseRemoval;

///List of chars to override tessedit_char_blacklist
///@brief Type STRING Default ""
extern NSString *const kG8ParamTesseditCharUnblacklist;

///fraction of linesize for min xheight
///@brief Type double Default 0.25
extern NSString *const kG8ParamTextordMinxh;

///Use divisible blobs chopping
///@brief Type BOOL Default true
extern NSString *const kG8ParamAllowBlobDivision;

///Factor for defining space threshold in terms of space and kern sizes
///@brief Type double Default 2.0
extern NSString *const kG8ParamTospOldSpKnThFactor;

///To avoid overly small denominators use this as the floor of the probability returned by the ngram model
///@brief Type double Default 0.000001
extern NSString *const kG8ParamLanguageModelNgramSmallProb;

///Non standard number of outlines
///@brief Type STRING Default "%| "
extern NSString *const kG8ParamOutlinesOdd;

///Log matcher activity
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditMatcherLog;

///Stopper debug level
///@brief Type INT Default 0
extern NSString *const kG8ParamStopperDebugLevel;

///Reject all bad quality wds
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditRejectBadQualWds;

///, Punct. chs expected WITHIN numbers
///@brief Type STRING Default ".
extern NSString *const kG8ParamNumericPunctuation;

///Save Document Words
///@brief Type BOOL Default 0
extern NSString *const kG8ParamSaveDocWords;

///Split sharpness adjustment
///@brief Type double Default 0.06
extern NSString *const kG8ParamChopSharpnessKnob;

///Il1 conflict set
///@brief Type STRING Default "Il1[]"
extern NSString *const kG8ParamConflictSetIL1;

///Integer Matcher Multiplier  0-255:
///@brief Type INT Default 10
extern NSString *const kG8ParamClassifyIntegerMatcherMultiplier;

///Don't Suspect dict wds longer than this
///@brief Type INT Default 2
extern NSString *const kG8ParamSuspectShortWords;

///Assume the input is numbers [0-9].
///@brief Type BOOL Default 0
extern NSString *const kG8ParamClassifyBlnNumericMode;

///%rej allowed before rej whole block
///@brief Type double Default 45.00
extern NSString *const kG8ParamTesseditRejectBlockPercent;

///Non-linear stroke-density normalization
///@brief Type BOOL Default 0
extern NSString *const kG8ParamClassifyNonlinearNorm;

///Only stat OBVIOUS spaces
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospRowUseCertSpaces;

///Individual rejection control
///@brief Type BOOL Default true
extern NSString *const kG8ParamRejUseTessAccepted;

///Maximum angle delta for prototype clustering
///@brief Type double Default 0.015
extern NSString *const kG8ParamMatcherClusteringMaxAngleDelta;

///Character Normalization Range ...
///@brief Type double Default 0.2
extern NSString *const kG8ParamClassifyCharNormRange;

///Run paragraph detection on the post-text-recognition (more accurate)
///@brief Type BOOL Default true
extern NSString *const kG8ParamParagraphTextBased;

///Split center adjustment
///@brief Type double Default 0.15
extern NSString *const kG8ParamChopCenterKnob;

///Use test xheight mechanism
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordNewInitialXheight;

///Fraction of x for big t count
///@brief Type double Default 0.5
extern NSString *const kG8ParamTextordNoiseSizelimit;

///Penalty to apply when a non-alnum is vertically out of its expected textline position
///@brief Type double Default 0.0
extern NSString *const kG8ParamClassifyMisfitJunkPenalty;

///Class str to debug learning
///@brief Type STRING Default ""
extern NSString *const kG8ParamClassifyLearnDebugStr;

///Do minimal rejection on pass 1 output
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditMinimalRejPass1;

///Fiddle alpha figures
///@brief Type BOOL Default false
extern NSString *const kG8ParamCrunchIncludeNumerals;

///Ile of sizes for xheight guess
///@brief Type double Default 0.90
extern NSString *const kG8ParamTextordInitialascIle;

///Filename extension
///@brief Type STRING Default ".tif"
extern NSString *const kG8ParamFileType;

///Use word segmentation quality metric
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDontBlkrejGoodWds;

///Test adaption criteria
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditTestAdaption;

///Adaption debug
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditRejectionDebug;

///New fuzzy kn alg
///@brief Type double Default 0.5
extern NSString *const kG8ParamTospFuzzyKnFraction;

///Reject spaces?
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditUseRejectSpaces;

///Enable adaptive classifier
///@brief Type BOOL Default true
extern NSString *const kG8ParamClassifyEnableLearning;

///Min char y-norm scale ...
///@brief Type double Default 0.0
extern NSString *const kG8ParamClassifyMinNormScaleY;

///Matcher Debug Flags
///@brief Type INT Default 0
extern NSString *const kG8ParamMatcherDebugFlags;

///Save alternative paths found during chopping and segmentation search
///@brief Type BOOL Default true
extern NSString *const kG8ParamSaveAltChoices;

///Use acceptability in okstring
///@brief Type BOOL Default true
extern NSString *const kG8ParamCrunchAcceptOk;

///Fraction of bounding box for noise
///@brief Type double Default 0.7
extern NSString *const kG8ParamTextordNoiseAreaRatio;

///Whitelist of chars to recognize
///@brief Type STRING Default ""
extern NSString *const kG8ParamTesseditCharWhitelist;

///Don't touch sensible strings
///@brief Type BOOL Default true
extern NSString *const kG8ParamCrunchLeaveOkStrings;

///xht multiplier
///@brief Type double Default 3.5
extern NSString *const kG8ParamTospIgnoreVeryBigGaps;

///good_quality_doc gte good char limit
///@brief Type double Default 0.95
extern NSString *const kG8ParamQualityCharPc;

///Enable correction based on the word bigram dictionary.
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditEnableBigramCorrection;

///Penalty to add to worst rating for noise
///@brief Type double Default 10.0
extern NSString *const kG8ParamSpeckleRatingPenalty;

///Display boxes
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordShowBoxes;

///Score multiplier for word matches that have good case (lower is better).
///@brief Type double Default 1.1
extern NSString *const kG8ParamSegmentPenaltyDictCaseOk;

///Page stats
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDebugDocRejection;

///Number of row rejects in whole word rejects which prevents whole row rejection
///@brief Type double Default 70.00
extern NSString *const kG8ParamTesseditWholeWdRejRowPercent;

///Class Pruner Threshold 0-255
///@brief Type INT Default 229
extern NSString *const kG8ParamClassifyClassPrunerThreshold;

///Try to improve fuzzy spaces
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditFixFuzzySpaces;

///Contextual 0O O0 flips
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditFlip0O;

///Min Outline Area
///@brief Type INT Default 2000
extern NSString *const kG8ParamChopMinOutlineArea;

///Don't reject ANYTHING
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditZeroRejection;

///According to dict_word
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditOverridePermuter;

///How to avoid being silly
///@brief Type INT Default 1
extern NSString *const kG8ParamTospSanityMethod;

///New fuzzy sp alg
///@brief Type double Default 0.5
extern NSString *const kG8ParamTospFuzzySpFraction;

///Avg. noise blob length:
///@brief Type double Default 12.0
extern NSString *const kG8ParamMatcherAvgNoiseSize;

///alphas in a good word
///@brief Type INT Default 2
extern NSString *const kG8ParamQualityMinInitialAlphasReqd;

///Multiplier on kn to limit thresh
///@brief Type double Default 5.0
extern NSString *const kG8ParamTospMaxSaneKnThresh;

///Good Match (0-1)
///@brief Type double Default 0.125
extern NSString *const kG8ParamMatcherGoodThreshold;

///Word for which stopper debug information should be printed to stdout
///@brief Type STRING Default ""
extern NSString *const kG8ParamWordToDebug;

///A suffix of user-provided words located in tessdata.
///@brief Type STRING Default ""
extern NSString *const kG8ParamUserWordsSuffix;

///Use row alone when inadequate cert spaces
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospRecoveryIsolatedRowStats;

///Extend permuter check
///@brief Type BOOL Default false
extern NSString *const kG8ParamRejUseSensibleWd;

///Associator Enable
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamWordrecEnableAssoc;

///Fraction of textlines deemed vertical to use vertical page mode
///@brief Type double Default 0.5
extern NSString *const kG8ParamTextordTabfindVerticalTextRatio;

///Top choice only from CP
///@brief Type INT Default FALSE
extern NSString *const kG8ParamTesseditSingleMatch;

///Scaling on certainty diff from Hingepoint
///@brief Type double Default 0.375
extern NSString *const kG8ParamNoiseCertFactor;

///Width of (smaller) chopped blobs above which we don't care that a chop is not near the center.
///@brief Type INT Default 90
extern NSString *const kG8ParamChopCenteredMaxwidth;

///Load frequent word dawg.
///@brief Type BOOL Default true
extern NSString *const kG8ParamLoadFreqDawg;

///Ile of gradients for page skew
///@brief Type double Default 0.5
extern NSString *const kG8ParamTextordSkewIle;

///Min desc/xheight
///@brief Type double Default 0.25
extern NSString *const kG8ParamTextordDescxRatioMin;

///Score multiplier for poorly cased strings that are not in the dictionary and generally look like garbage (lower is better).
///@brief Type double Default 1.50
extern NSString *const kG8ParamSegmentPenaltyGarbage;

///Create PDF with only one invisible text layer
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextonlyPdf;

///Split Length
///@brief Type INT Default 10000
extern NSString *const kG8ParamChopSplitLength;

///Write all parameters to the given file.
///@brief Type STRING Default ""
extern NSString *const kG8ParamTesseditWriteParamsToFile;

///Use old xheight algorithm
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordOldXheight;

///Threshold for good protos during adaptive 0-255
///@brief Type INT Default 230
extern NSString *const kG8ParamClassifyAdaptProtoThreshold;

///Debug line finding
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordTabfindShowVlines;

///Use two different windows for debugging the matching: One for the protos and one for the features.
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamMatcherDebugSeparateWindows;

///Character Normalized Matching
///@brief Type BOOL Default 0
extern NSString *const kG8ParamTessCnMatching;

///Size of window for spline segmentation
///@brief Type INT Default 6
extern NSString *const kG8ParamTextordSplineMedianwin;

///Default flip
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospFlipFuzzSpToKn;

///Make AcceptableChoice() always return false. Useful when there is a need to explore all segmentations
///@brief Type BOOL Default false
extern NSString *const kG8ParamStopperNoAcceptableChoices;

///Worst segmentation state
///@brief Type double Default 1
extern NSString *const kG8ParamWordrecWorstState;

///Use old baseline algorithm
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordOldBaselines;

///Transitions for normal blob
///@brief Type INT Default 16
extern NSString *const kG8ParamTextordNoiseTranslimit;

///Output font info per char
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDebugFonts;

///Reject noise-like rows
///@brief Type BOOL Default true
extern NSString *const kG8ParamTextordNoiseRejrows;

///Use CJK fixed pitch model
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordUseCjkFpModel;

///Maximum order of the character ngram model
///@brief Type INT Default 8
extern NSString *const kG8ParamLanguageModelNgramOrder;

///Don't crunch words with long lower case strings
///@brief Type INT Default 4
extern NSString *const kG8ParamCrunchLeaveLcStrings;

///Threshold at which classify_adapted_pruning_factor starts
///@brief Type double Default -1.0
extern NSString *const kG8ParamClassifyAdaptedPruningThreshold;

///Small if lt xht x this
///@brief Type double Default 0.28
extern NSString *const kG8ParamFixspSmallOutlinesSize;

///Debug level for wordrec
///@brief Type INT Default 0
extern NSString *const kG8ParamWordrecDebugLevel;

///2nd Trailing punctuation
///@brief Type STRING Default ")'`\""
extern NSString *const kG8ParamChsTrailingPunct2;

///1st Trailing punctuation
///@brief Type STRING Default ").,;:?!"
extern NSString *const kG8ParamChsTrailingPunct1;

///Minimum length of compound words
///@brief Type INT Default 3
extern NSString *const kG8ParamLanguageModelMinCompoundLength;

///Display rows after expanding
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordShowExpandedRows;

///Load dawg with punctuation patterns.
///@brief Type BOOL Default true
extern NSString *const kG8ParamLoadPuncDawg;

///Force word breaks on punct to break long lines in non-space delimited langs
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospForceWordbreakOnPunct;

///Limit use of xht gap with odd small kns
///@brief Type double Default -1
extern NSString *const kG8ParamTospDontFoolWithSmallKerns;

///Ile of sizes for xheight guess
///@brief Type double Default 0.75
extern NSString *const kG8ParamTextordInitialxIle;

///Use only the first UTF8 step of the given string when computing log probabilities
///@brief Type BOOL Default false
extern NSString *const kG8ParamLanguageModelNgramUseOnlyFirstUft8Step;

///Number of linew fits to do
///@brief Type INT Default 12
extern NSString *const kG8ParamTextordLmsLineTrials;

///Amount of debug output for bigram correction.
///@brief Type INT Default 0
extern NSString *const kG8ParamTesseditBigramDebug;

///Worst certainty for using pending dictionary
///@brief Type double Default 0.0
extern NSString *const kG8ParamDocDictPendingThreshold;

///Page seg mode: 0=osd only, 1=auto+osd, 2=auto, 3=col, 4=block, 5=line, 6=word, 7=char (Values from PageSegMode enum in publictypes.h)
///@brief Type INT Default PSM_SINGLE_BLOCK
extern NSString *const kG8ParamTesseditPagesegMode;

///For smooth factor
///@brief Type INT Default 1
extern NSString *const kG8ParamTextordSkewsmoothOffset2;

///No.gaps reqd with 1 large gap to treat as a table
///@brief Type INT Default 40
extern NSString *const kG8ParamTospFewSamples;

///Dump char choices
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDumpChoices;

///Tests refer to land/port
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordTestLandscape;

///Non standard number of outlines
///@brief Type STRING Default "ij!?%\":;"
extern NSString *const kG8ParamOutlines2;

///Crunch double hyphens?
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditFixHyphens;

///Matcher Debug Level
///@brief Type INT Default 0
extern NSString *const kG8ParamMatcherDebugLevel;

///Max diacritics to apply to a word
///@brief Type INT Default 16
extern NSString *const kG8ParamNoiseMaxperword;

///UNLV keep 1Il chars rejected
///@brief Type BOOL Default false
extern NSString *const kG8ParamSuspectConstrain1Il;

///Same distance
///@brief Type INT Default 2
extern NSString *const kG8ParamChopSameDistance;

///Prune poor adapted results this much worse than best result
///@brief Type double Default 2.5
extern NSString *const kG8ParamClassifyAdaptedPruningFactor;

///Allow outline errs in unrejection?
///@brief Type BOOL Default false
extern NSString *const kG8ParamDocqualExcuseOutlineErrs;

///Leading punctuation
///@brief Type STRING Default "('`\""
extern NSString *const kG8ParamChsLeadingPunct;

///Bring up graphical debugging windows for fragments training
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamClassifyDebugCharacterFragments;

///List of languages to load with this one
///@brief Type STRING Default ""
extern NSString *const kG8ParamTesseditLoadSublangs;

///Min blob height/top to include blob top into xheight stats
///@brief Type double Default 0.75
extern NSString *const kG8ParamTextordMinBlobHeightFraction;

///Turn on equation detector
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordEquationDetect;

///good_quality_doc lte rejection limit
///@brief Type double Default 0.08
extern NSString *const kG8ParamQualityRejPc;

///Exposure value follows this pattern in the image filename. The name of the image files are expected to be in the form [lang].[fontname].exp[num].tif
///@brief Type STRING Default ".exp"
extern NSString *const kG8ParamApplyboxExposurePattern;

///Display row accumulation
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordShowInitialRows;

///Thresh guess - mult xht by this
///@brief Type double Default 0.28
extern NSString *const kG8ParamTospInitGuessXhtMult;

///Multiple of line_size for underline
///@brief Type double Default 2.0
extern NSString *const kG8ParamTextordUnderlineWidth;

///Max certaintly variation allowed in a word (in sigma)
///@brief Type double Default 3.0
extern NSString *const kG8ParamStopperAllowableCharacterBadness;

///Limit use of xht gap with large kns
///@brief Type double Default 0.19
extern NSString *const kG8ParamTospLargeKerning;

///include fixed-pitch heuristics in char segmentation
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamAssumeFixedPitchCharSegment;

///Min credible pixel xheight
///@brief Type INT Default 10
extern NSString *const kG8ParamTextordMinXheight;

///Set to 1 for general debug info , to 2 for more details, to 3 to see all the debug messages
///@brief Type INT Default 0
extern NSString *const kG8ParamDawgDebugLevel;

///Adaptation decision algorithm for tess
///@brief Type INT Default 0x27
extern NSString *const kG8ParamTesseditTessAdaptionMode;

///Display rows after final fitting
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordShowFinalRows;

///Max char x-norm scale ...
///@brief Type double Default 0.325
extern NSString *const kG8ParamClassifyMaxNormScaleX;

///Max char y-norm scale ...
///@brief Type double Default 0.325
extern NSString *const kG8ParamClassifyMaxNormScaleY;

///Don't chng kn to space next to punct
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospRule9TestPunct;

///Don't autoflip kn to sp when large separation
///@brief Type double Default 0.0
extern NSString *const kG8ParamTospFlipCaution;

///Each bounding box is assumed to contain ngrams. Only learn the ngrams whose outlines overlap horizontally.
///@brief Type BOOL Default false
extern NSString *const kG8ParamApplyboxLearnNgramsMode;

///Small if lt xht x this
///@brief Type double Default 0.6
extern NSString *const kG8ParamCrunchSmallOutlinesSize;

///%rej allowed before rej whole doc
///@brief Type double Default 65.00
extern NSString *const kG8ParamTesseditRejectDocPercent;

///Penalty for inconsistent punctuation
///@brief Type double Default 0.2
extern NSString *const kG8ParamLanguageModelPenaltyPunc;

///ycoord
///@brief Type double Default 99999.99
extern NSString *const kG8ParamTestPtY;

///Load dawg with special word bigrams.
///@brief Type BOOL Default true
extern NSString *const kG8ParamLoadBigramDawg;

///Bad Match Pad (0-1)
///@brief Type double Default 0.15
extern NSString *const kG8ParamMatcherBadMatchPad;

///Max iqr/median for linespace
///@brief Type double Default 0.2
extern NSString *const kG8ParamTextordLinespaceIqrlimit;

///Great Match (0-1)
///@brief Type double Default 0.0
extern NSString *const kG8ParamMatcherReliableAdaptiveResult;

///Debug level
///@brief Type INT Default 1
extern NSString *const kG8ParamApplyboxDebug;

///Enable improvement heuristic
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospImproveThresh;

///Dump intermediate images made during page segmentation
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDumpPagesegImages;

///Baseline debug level
///@brief Type INT Default 0
extern NSString *const kG8ParamTextordBaselineDebug;

///No.gaps reqd with few cert spaces to use certs
///@brief Type INT Default 20
extern NSString *const kG8ParamTospShortRow;

///Score penalty (0.1 = 10%) added if there are subscripts or superscripts in a word, but it is otherwise OK.
///@brief Type double Default 0.125
extern NSString *const kG8ParamXheightPenaltySubscripts;

///Hingepoint for base char certainty
///@brief Type double Default -8.0
extern NSString *const kG8ParamNoiseCertBasechar;

///Take out ~^ early?
///@brief Type BOOL Default false
extern NSString *const kG8ParamCrunchEarlyConvertBadUnlvChs;

///Before word crunch?
///@brief Type BOOL Default true
extern NSString *const kG8ParamCrunchEarlyMergeTessFails;

///Interpolate across gaps
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordInterpolatingSkew;

///Aspect ratio dot/hyphen test
///@brief Type double Default 1.5
extern NSString *const kG8ParamTesseditLowerFlipHyphen;

///Better guess
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospOnlySmallGapsForKern;

///Enable adaption even if the ambiguities have not been seen
///@brief Type INT Default 5
extern NSString *const kG8ParamMatcherSufficientExamplesForPrototyping;

///What reduction in badness do we think sufficient to choose a superscript over what we'd thought.  For example, a value of 0.6 means we want to reduce badness of certainty by 40%
///@brief Type double Default 0.97
extern NSString *const kG8ParamSuperscriptBetteredCertainty;

///Chop enable
///@brief Type BOOL Default 1
extern NSString *const kG8ParamChopEnable;

///As it says
///@brief Type BOOL Default true
extern NSString *const kG8ParamCrunchTerribleGarbage;

///Reward punctuation joins
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditPreferJoinedPunct;

///Reliable Config Threshold
///@brief Type INT Default 3
extern NSString *const kG8ParamMatcherMinExamplesForPrototyping;

///Only preserve wds longer than this
///@brief Type INT Default 2
extern NSString *const kG8ParamTesseditPreserveMinWdLen;

///-1 -> All pages, else specific page to process
///@brief Type INT Default -1
extern NSString *const kG8ParamTesseditPageNumber;

///Draw output words
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDisplayOutwords;

///Use word segmentation quality metric
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDontRowrejGoodWds;

///Min Inside Angle Bend
///@brief Type INT Default -50
extern NSString *const kG8ParamChopInsideAngle;

///Print test blob information
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamTextordDebugBlob;

///Max cap/xheight
///@brief Type double Default 1.8
extern NSString *const kG8ParamTextordAscxRatioMax;

///Display Segmentations
///@brief Type INT Default 0
extern NSString *const kG8ParamWordrecDisplaySegmentations;

///Output file for ambiguities found in the dictionary
///@brief Type STRING Default ""
extern NSString *const kG8ParamOutputAmbigWordsFile;

///Don't restrict kn->sp fuzzy limit to tables
///@brief Type BOOL Default true
extern NSString *const kG8ParamTospFuzzyLimitAll;

///A filename of user-provided patterns.
///@brief Type STRING Default ""
extern NSString *const kG8ParamUserPatternsFile;

///if >this fract
///@brief Type double Default 0.85
extern NSString *const kG8ParamRejWholeOfMostlyRejectWordFract;

///New row made if blob makes row this big
///@brief Type double Default 1.3
extern NSString *const kG8ParamTextordExcessBlobsize;

///Fix blobs that aren't chopped
///@brief Type INT Default 1
extern NSString *const kG8ParamRepairUnchoppedBlobs;

///Reject certainty offset
///@brief Type double Default 1.0
extern NSString *const kG8ParamStopperPhase2CertaintyRejectionOffset;

///Max baseline shift
///@brief Type double Default 0.00
extern NSString *const kG8ParamTextordBlshiftMaxshift;

///Percentile for large blobs
///@brief Type double Default 95
extern NSString *const kG8ParamTextordBlobSizeBigile;

///Reject any x-ht lt or eq than this
///@brief Type INT Default 8
extern NSString *const kG8ParamMinSaneXHtPixels;

///force associator to run regardless of what enable_assoc is. This is used for CJK where component grouping is necessary.
///@brief Type BOOL Default FALSE
extern NSString *const kG8ParamForceWordAssoc;

///Thresh guess - mult kn by this
///@brief Type double Default 2.2
extern NSString *const kG8ParamTospInitGuessKnMult;

///Force using vertical text page mode
///@brief Type BOOL Default false
extern NSString *const kG8ParamTextordTabfindForceVerticalText;

///Maximum character width-to-height ratio
///@brief Type double Default 2.0
extern NSString *const kG8ParamSegsearchMaxCharWhRatio;

///Maximum number of pain points stored in the queue
///@brief Type INT Default 2000
extern NSString *const kG8ParamSegsearchMaxPainPoints;

///Use new seam_pile
///@brief Type BOOL Default 1
extern NSString *const kG8ParamChopNewSeamPile;

///Max number of blobs a big blob can overlap
///@brief Type INT Default 4
extern NSString *const kG8ParamTextordMaxBlobOverlaps;

///Block and Row stats
///@brief Type BOOL Default false
extern NSString *const kG8ParamTesseditDebugBlockRejection;

///Don't reduce box if the top left is non blank
///@brief Type double Default 0
extern NSString *const kG8ParamTospNearLhEdge;

///Add font info to hocr output
///@brief Type BOOL Default false
extern NSString *const kG8ParamHocrFontInfo;

///gap ratio to flip kern->sp
///@brief Type double Default 1.3
extern NSString *const kG8ParamTospKernGapFactor2;

///gap ratio to flip kern->sp
///@brief Type double Default 2.5
extern NSString *const kG8ParamTospKernGapFactor3;

///gap ratio to flip kern->sp
///@brief Type double Default 2.0
extern NSString *const kG8ParamTospKernGapFactor1;

///Debug level for BiDi
///@brief Type INT Default 0
extern NSString *const kG8ParamBidiDebug;

///Don't double check
///@brief Type BOOL Default true
extern NSString *const kG8ParamRej1IlTrustPermuterType;

///Fix suspected bug in old code
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospOldToBugFix;

///Check/Correct x-height
///@brief Type BOOL Default true
extern NSString *const kG8ParamTesseditRedoXheight;

///What constitues done for spacing
///@brief Type INT Default 1
extern NSString *const kG8ParamFixspDoneMode;

///Bias skew estimates with line length
///@brief Type BOOL Default TRUE
extern NSString *const kG8ParamTextordBiasedSkewcalc;

///Only use within xht gap for wd breaks
///@brief Type BOOL Default false
extern NSString *const kG8ParamTospOnlyUseXhtGaps;

#endif
