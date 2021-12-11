//
//  ContentView.swift
//  instaFilter
//
//  Created by Sree on 11/12/21.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var  image: Image?
    @State private var  filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterSheet = false
    @State private var proccessedImage: UIImage?
    
    let context = CIContext()
    
    var body: some View {
        NavigationView{
        VStack{
            ZStack{
                Rectangle().fill(.secondary)
                Text("Tap to select the image").foregroundColor(Color.white)
                    .font(.headline)
                image?.resizable().scaledToFit()
            }.onTapGesture {
                showingImagePicker = true
            }
            
            HStack{
                Text("Filter Intensity")
                Slider(value: $filterIntensity).onChange(of: filterIntensity) { _ in  applyProcessing() }
            }
            
            HStack{
                Button("Change Filter"){ showingFilterSheet = true }
                Spacer()
                Button("Save",action:save)
            }
            
        }.navigationTitle("Insta Filter")
        .padding([.horizontal,.vertical])
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }.confirmationDialog("Select Filter", isPresented: $showingFilterSheet){
            Button("Crystallize") { setfilter(CIFilter.crystallize()) }
            Button("Edges") { setfilter(CIFilter.edges()) }
            Button("Blur") { setfilter(CIFilter.gaussianBlur()) }
            Button("Pixelate") { setfilter(CIFilter.pixellate()) }
            Button("Sepia Tone") { setfilter(CIFilter.sepiaTone()) }
            Button("Vignette") { setfilter(CIFilter.vignette()) }
            Button("Close",role: .cancel) { }
        }
    }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image:inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let proccessedImage = proccessedImage else {
            return
        }
        let imageSaver = ImageSaver()
        
        
        imageSaver.successHandler = {
            print("Success")
        }
        
        imageSaver.errorHandler = { error in
            print(error.localizedDescription)
        }
        
        imageSaver.writeToPhotoAlbum(image: proccessedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){ currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)  }
        
        if inputKeys.contains(kCIInputRadiusKey){ currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)  }
        
        if inputKeys.contains(kCIInputScaleKey){ currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)  }
        
       
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent){
            let uiimg = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiimg)
            proccessedImage = uiimg
        }
    }
    
    func setfilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
