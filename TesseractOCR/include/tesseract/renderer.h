///////////////////////////////////////////////////////////////////////
// File:        renderer.h
// Description: Rendering interface to inject into TessBaseAPI
//
// (C) Copyright 2011, Google Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
///////////////////////////////////////////////////////////////////////

#ifndef TESSERACT_API_RENDERER_H__
#define TESSERACT_API_RENDERER_H__

// To avoid collision with other typenames include the ABSOLUTE MINIMUM
// complexity of includes here. Use forward declarations wherever possible
// and hide includes of complex types in baseapi.cpp.
#include "genericvector.h"
#include "platform.h"
#include "publictypes.h"

namespace tesseract {

class TessBaseAPI;

/**
 * Interface for rendering tesseract results into a document, such as text,
 * HOCR or pdf. This class is abstract. Specific classes handle individual
 * formats. This interface is then used to inject the renderer class into
 * tesseract when processing images.
 *
 * For simplicity implementing this with tesesract version 3.01,
 * the renderer contains document state that is cleared from document
 * to document just as the TessBaseAPI is. This way the base API can just
 * delegate its rendering functionality to injected renderers, and the
 * renderers can manage the associated state needed for the specific formats
 * in addition to the heuristics for producing it.
 */
class TESS_API TessResultRenderer {
  public:
    virtual ~TessResultRenderer();

    // Takes ownership of pointer so must be new'd instance.
    // Renderers arent ordered, but appends the sequences of next parameter
    // and existing next(). The renderers should be unique across both lists.
    void insert(TessResultRenderer* next);

    // Returns the next renderer or NULL.
    TessResultRenderer* next() { return next_; }

    /**
     * Starts a new document with the given title.
     * This clears the contents of the output data.
     */
    bool BeginDocument(const char* title);

    /**
     * Adds the recognized text from the source image to the current document.
     * Invalid if BeginDocument not yet called.
     *
     * Note that this API is a bit weird but is designed to fit into the
     * current TessBaseAPI implementation where the api has lots of state
     * information that we might want to add in.
     */
    bool AddImage(TessBaseAPI* api);

    /**
     * Called to inform the renderer when tesseract failed on an image.
     */
    bool AddError(TessBaseAPI* api);

    /**
     * Finishes the document and finalizes the output data
     * Invalid if BeginDocument not yet called.
     */
    bool EndDocument();

    const char* full_typename() const { return full_typename_; }
    const char* file_extension() const { return file_extension_; }
    const char* title() const { return title_; }

    /**
     * Returns the index of the last image given to AddImage or AddError
     * (i.e. images are incremented whether the image succeeded or not)
     *
     * This is always defined. It means either the number of the
     * current image, the last image ended, or in the completed document
     * depending on when in the document lifecycle you are looking at it.
     * Will return -1 if a document was never started.
     */
    int imagenum() const { return imagenum_; }

    /**
     * The results are not defined if EndDocument has not yet been called.
     * Returns the current output from the renderer. The data is owned by
     * the renderer and only valid until the next call into the renderer
     * that may modify document state (such as Begin/End Document
     * or AddImage.
     */
    virtual bool GetOutput(const char** data, int* data_len) const;

  protected:
    /**
     * Called by concrete classes
     */
    TessResultRenderer(const char* type, const char* extension);

    // Hook for specialized handling in BeginDocument()
    virtual bool BeginDocumentHandler();

    // This must be overriden to render the OCR'd results
    virtual bool AddImageHandler(TessBaseAPI* api) = 0;

    // The default handler ignores the error and just returns true
    virtual bool AddErrorHandler(TessBaseAPI* api);

    // Hook for specialized handling in EndDocument()
    virtual bool EndDocumentHandler();

    // Clear output data.
    void ResetData();

    // Renderers can call this method to allocate data storage in advance,
    // which can cut down on allocations and copying. This isnt required,
    // and if used can still request less than will ultimately be used without
    // worrying about data corruption. It's purely performance.
    // Note that relative_len is in addition to what is already being used.
    void ReserveAdditionalData(int relative_len);

    // Renderers can call this to append '\0' terminated strings into
    // the output string returned by GetOutput.
    // This method will grow the output buffer if needed.
    void AppendString(const char* s);

    // Renderers can call this to append binary byte sequences into
    // the output string returned by GetOutput. Note that s is not necessarily
    // '\0' terminated (and can contain '\0' within it).
    // This method will grow the output buffer if needed.
    void AppendData(const char* s, int len);

  private:
    const char* full_typename_;   // name of renderer
    const char* file_extension_;  // standard extension for generated output
    const char* title_;           // title of document being renderered
    int imagenum_;                // index of last image added

    char* output_data_;           // output bytes
    int   output_alloc_;          // bytes allocated
    int   output_len_;            // bytes actually used
    TessResultRenderer* next_;    // Can link multiple renderers together.
};

/**
 * Renders tesseract output into a plain UTF-8 text string
 */
class TESS_API TessTextRenderer : public TessResultRenderer {
 public:
  TessTextRenderer();

 protected:
  virtual bool AddImageHandler(TessBaseAPI* api);
};

/**
 * Renders tesseract output into an hocr text string
 */
class TESS_API TessHOcrRenderer : public TessResultRenderer {
 public:
  TessHOcrRenderer();

protected:
  virtual bool BeginDocumentHandler();
  virtual bool AddImageHandler(TessBaseAPI* api);
  virtual bool EndDocumentHandler();
};

/**
 * Renders tesseract output into searchable PDF
 */
class TESS_API TessPDFRenderer : public TessResultRenderer {
 public:
    // datadir is the location of the TESSDATA. We need it because
    // we load a custom PDF font from this location.
    TessPDFRenderer(const char *outputbase, const char *datadir);
    
    // Sets the PDFs creator property to the given value.
    virtual void setCreator(const char *creator) { creator_ = creator; }
    // Returns the current PDFs creator property value. Default is "Scanbot".
    const char *creator() { return creator_; }

protected:
  virtual bool BeginDocumentHandler();
  virtual bool AddImageHandler(TessBaseAPI* api);
  virtual bool EndDocumentHandler();

private:
    // We don't want to have every image in memory at once,
    // so we store some metadata as we go along producing
    // PDFs one page at a time. At the end that metadata is
    // used to make everything that isn't easily handled in a
    // streaming fashion.
    long int obj_;                     // counter for PDF objects
    GenericVector<long int> offsets_;  // offset of every PDF object in bytes
    GenericVector<long int> pages_;    // object number for every /Page object
    const char *datadir_;              // where to find the custom font
    const char *creator_ = "Tesseract";
    // Bookkeeping only. DIY = Do It Yourself.
    void AppendPDFObjectDIY(size_t objectsize);
    // Bookkeeping + emit data.
    void AppendPDFObject(const char *data);
    // Create the /Contents object for an entire page.
    static char* GetPDFTextObjects(TessBaseAPI* api,
                                   double width, double height);
    // Turn an image into a PDF object. Only transcode if we have to.
    static bool imageToPDFObj(Pix *pix, char *filename, long int objnum,
                              char **pdf_object, long int *pdf_object_size);
};


/**
 * Renders tesseract output into a plain UTF-8 text string
 */
class TESS_API TessUnlvRenderer : public TessResultRenderer {
public:
    explicit TessUnlvRenderer(const char *outputbase);
    
protected:
    virtual bool AddImageHandler(TessBaseAPI* api);
};

/**
 * Renders tesseract output into a plain UTF-8 text string
 */
class TESS_API TessBoxTextRenderer : public TessResultRenderer {
public:
    explicit TessBoxTextRenderer(const char *outputbase);
    
protected:
    virtual bool AddImageHandler(TessBaseAPI* api);
};

}  // namespace tesseract.

#endif  // TESSERACT_API_RENDERER_H__
