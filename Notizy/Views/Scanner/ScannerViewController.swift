//
//  ScannerViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 02.12.22.
//

import UIKit
import Vision
import VisionKit
import PDFKit
import PhotosUI


class ScannerViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    
    
    @IBOutlet weak var vorschauDoc: UIImageView?
    
    //MARK: Variables
    let pdfVista = PDFView()
    let scanVC = VNDocumentCameraViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pdfVista.delegate = self
        scanVC.delegate = self
        
        vorschauDoc?.isUserInteractionEnabled = true
        vorschauDoc?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previsualizar)))
        
        present(scanVC, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfVista.frame = view.bounds
    }
    
    @objc func previsualizar(){
        performSegue(withIdentifier: "verDocumento", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDocumento" {
            let documento = segue.destination as! DocumentenViewController
            documento.recibirDocumentoMostrar = vorschauDoc?.image
        }
    }
    
    @IBAction func galerieBTN(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func savePDFButton(_ sender: UIBarButtonItem) {
        
        cargarPDF()
        
        let alert = UIAlertController(title: "AUFMERKSAMKEIT", message: "Möchten Sie dieses Dokument als PDF speichern?", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Ja", style: .default) { _ in
            let vc = UIActivityViewController(activityItems: [self.pdfVista.document?.dataRepresentation()!], applicationActivities: [])
            self.present(vc, animated: true)
        }
        alert.addAction(accionAceptar)
        alert.addAction(UIAlertAction(title: "Nein", style: .destructive))
        present(alert, animated: true)
        
    }
    
    func cargarPDF(){
        vorschauDoc?.addSubview(pdfVista)
        
        //Crear el documento a mostrar
        let documento = PDFDocument()
        guard let pagina = PDFPage(image: vorschauDoc?.image ?? UIImage(systemName: "car")!) else { return }
        documento.insert(pagina, at: 0)
        
        pdfVista.document = documento
        
        //Gestaltung und Visualisierung
        pdfVista.autoScales = true
        pdfVista.usePageViewController(true)
        
    }
    
    @IBAction func TakeAgainButton(_ sender: UIBarButtonItem) {
        present(scanVC, animated: true)
    }
    
    
    
    //MARK: Delegate
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        if scan.pageCount > 0 {
            
            vorschauDoc?.image = scan.imageOfPage(at: 0)
            controller.dismiss(animated: true)
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) {
            let alert = UIAlertController(title: "AUFMERKSAMKEIT", message: "", preferredStyle: .alert)
            let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
                // mach Etwas
            }
            alert.addAction(accionAceptar)
            self.present(alert, animated: true)
        }
    }
    
    
}

extension ScannerViewController: PDFViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            vorschauDoc?.image = imagenSeleccionada
            //Aktualisieren Sie das erstellte PDF mit dieser Seite, die dem PDF-Dokument hinzugefügt wird
            cargarPDF()
            
            picker.dismiss(animated: true)
            
        }
    }
    
}


