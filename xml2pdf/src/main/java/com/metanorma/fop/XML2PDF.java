package com.metanorma.fop;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.fop.apps.FOPException;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;

import net.sourceforge.jeuclid.fop.plugin.JEuclidFopFactoryConfigurator;
import org.xml.sax.SAXException;


/**
 * This class for the conversion of an XML file to PDF using FOP and JEuclid
 */
public class XML2PDF {
    
    /**
     * Converts an XML file to a PDF file using FOP
     * @param config the FOP config file
     * @param xml the XML source file
     * @param xsl the XSL file
     * @param pdf the target PDF file
     * @throws IOException In case of an I/O problem
     * @throws FOPException, SAXException In case of a FOP problem
     */
    public void convertXML2PDF(File config, File xml, File xsl, File pdf) throws IOException, FOPException, SAXException, TransformerException, TransformerConfigurationException, TransformerConfigurationException {

        OutputStream out = null;
        try {
            // Step 0. Convert XML to FO file with XSL
            //Setup XSLT
            TransformerFactory factory = TransformerFactory.newInstance();
            Transformer transformer = factory.newTransformer(new StreamSource(xsl));
            
            //Setup input for XSLT transformation
            Source src = new StreamSource(xml);
            
            //Setup output
            StringWriter resultWriter = new StringWriter();
            StreamResult sr = new StreamResult(resultWriter);
            
            //Start XSLT transformation and FOP generating
            transformer.transform(src, sr);
            String xmlFO = resultWriter.toString();
                    
            // Step 1: Construct a FopFactory by specifying a reference to the configuration file
            // (reuse if you plan to render multiple documents!)
            FopFactory fopFactory = FopFactory.newInstance(config);

          
            JEuclidFopFactoryConfigurator.configure(fopFactory);
            FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
            // configure foUserAgent as desired

            // Setup output stream.  Note: Using BufferedOutputStream
            // for performance reasons (helpful with FileOutputStreams).
            out = new FileOutputStream(pdf);
            out = new BufferedOutputStream(out);

            // Construct fop with desired output format
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, out);

            // Setup JAXP using identity transformer
            factory = TransformerFactory.newInstance();
            transformer = factory.newTransformer(); // identity transformer
           
            // Setup input stream
            Source srcFO = new StreamSource(new StringReader(xmlFO));

            // Resulting SAX events (the generated FO) must be piped through to FOP
            Result res = new SAXResult(fop.getDefaultHandler());

            // Start XSLT transformation and FOP processing
            transformer.transform(srcFO, res);

        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(-1);
        } finally {
            out.close();
        }
    }

    
    /**
     * Main method.
     * @param args command-line arguments
     */
    public static void main(String[] args) {
        if (args.length != 4) {
            System.out.println("Usage: java -jar xml2pdf <path to XML config file> <path to source XML file> <path to source XSLT file> <path to output PDF");
            System.exit(-1);
        }
        
        try {
            System.out.println("XML2PDF\n");
            System.out.println("Preparing...");
            
            //Setup config, input and output files
            final String argConfig = args[0];
            File fConfig = new File(argConfig);
            if (!fConfig.exists()) {
                System.out.println("Error: XML config file '" + fConfig + "' not found!");
                System.exit(-1);
            }
            final String argXML = args[1];
            File fXML = new File(argXML);
            if (!fXML.exists()) {
                System.out.println("Error: source XML file '" + fXML + "' not found!");
                System.exit(-1);
            }
            final String argXSL = args[2];
            File fXSL = new File(argXSL);
            if (!fXSL.exists()) {
                System.out.println("Error: XSL file '" + fXSL + "' not found!");
                System.exit(-1);
            }
            final String argPDF = args[3];
            File fPDF = new File(argPDF);        

            System.out.println("Input: FOP config (" + fConfig + ")");
            System.out.println("Input: XML (" + fXML + ")");
            System.out.println("Input: XSL (" + fXSL + ")");
            System.out.println("Output: PDF (" + fPDF + ")");
            System.out.println();
            System.out.println("Transforming...");

            XML2PDF app = new XML2PDF();
            app.convertXML2PDF(fConfig, fXML, fXSL, fPDF);

            System.out.println("Success!");
        } catch (Exception e) {
            e.printStackTrace(System.err);
            System.exit(-1);
        }
        
    }
    
}
