//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Elisangela Pethke on 27.06.24.
//

import UIKit

class MemeGeneratorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var lowerTextGield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var photoAlbum: UIBarButtonItem!
    @IBOutlet weak var fixedSpace: UIBarButtonItem!
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .strokeWidth: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDelegates()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        cameraButton.isEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            imageView.image = chosenImage
        }
        
        buttonShare.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectImageFromCamera(_ sender: Any) {
        presentImagePicker(source: .camera)
    }
    
    @IBAction func selectImagefromAlbum(_ sender: Any) {
        presentImagePicker(source: .photoLibrary)
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
        let memeImage = createMemeImage()
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                print("Error sharing meme: \(error.localizedDescription)")
            }
        }
        
    }
    
    func setupUI() {
        
        buttonShare.isEnabled = false
        cameraButton.isEnabled = false
        imageView.contentMode = .scaleAspectFit
        configureTextField(upperTextField, with: memeTextAttributes)
        configureTextField(lowerTextGield, with: memeTextAttributes)
    }
    
    func configureTextField(_ textField: UITextField, with attributes: [NSAttributedString.Key: Any]) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }
    
    func configureDelegates() {
        upperTextField.delegate = self
        lowerTextGield.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if upperTextField.text == "TOP" && upperTextField.isTouchInside == true {
            lowerTextGield.text = ""
        }
        if lowerTextGield.text == "BOTTOM" && lowerTextGield.isTouchInside == true {
            lowerTextGield.text = ""
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let stringRange = Range(range, in: currentText)!
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string.uppercased())
        textField.text = updatedText
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if upperTextField.text == "" {
            upperTextField.text = "TOP"
        }
        if lowerTextGield.text == "" {
            lowerTextGield.text = "BOTTOM"
        }
    }
    
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func saveMeme() {
        
        guard let upperText = upperTextField.text, let lowerText = lowerTextGield.text else {
            print("Error: Upper text or lower text is nil")
            return
        }
        
        let memeImage = createMemeImage()
        let meme = CustomMeme(upperText: upperText, lowerText: lowerText, memeImage: memeImage)
        
        saveMemeToAppDelegate(meme)
    }
    
    func saveMemeToAppDelegate(_ meme: CustomMeme) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Verifica se o meme já existe na lista
        if appDelegate.meme.contains(where: { $0.upperText == meme.upperText && $0.lowerText == meme.lowerText }) {
            print("Este meme já foi salvo anteriormente.")
        } else {
            appDelegate.meme.append(meme)
            print("Meme salvo com sucesso!")
        }
    }
    
    func createMemeImage() -> UIImage {
        toolbar.isHidden = true
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if upperTextField.isEditing == true {
            upperTextField.resignFirstResponder()
        } else if lowerTextGield.isEditing == true {
            lowerTextGield.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var shouldMoveViewUp = false
        
        if let activeTextField = findActiveTextField() {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func findActiveTextField() -> UITextField? {
        if upperTextField.isFirstResponder {
            return upperTextField
        } else if lowerTextGield.isFirstResponder {
            return lowerTextGield
        }
        return nil
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

