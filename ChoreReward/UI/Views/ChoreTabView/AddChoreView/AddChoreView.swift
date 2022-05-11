//
//  AddChoreView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import SwiftUI

struct AddChoreView: View {
    @ObservedObject var addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>
    @State var choreTitle = ""
    @State var choreDescription = ""
    @State var isPresentingImagePicker = false
    @State var choreImage: UIImage? = nil
    @Environment(\.dismiss) var dismiss
    private var views: Dependency.Views
    
    init(
        addChoreViewModel: ObservableViewModel<AddChoreState, AddChoreAction>,
        views: Dependency.Views
    ){
        self.addChoreViewModel = addChoreViewModel
        self.views = views
    }
    
    var body: some View {
        RegularNavBarView(navTitle: "New Chore") {
            
            VStack{
                Group{
                    if let choreImage = choreImage {
                        Image(uiImage: choreImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipped()
                    }
                    else{
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .foregroundColor(.fg)
                            Text("Add photo")
                        }
                        
                    }
                }
                .shadow(radius: 5)
                .padding()
                .onTapGesture {
                    isPresentingImagePicker = true
                }
                TextFieldView(title: "Title", textInput: $choreTitle)
                    .padding()
                //TextFieldView(textInput: $choreDescription, title: "Description")
                TextEditor(text: $choreDescription)
                    .shadow(radius: 5)
                    .foregroundColor(.red)
                    .padding()
                Spacer()
                ButtonView(buttonTitle: "Create Chore", buttonImage: "plus") {
                    dismiss()
                    addChoreViewModel.perform(
                        action: .createChore(choreTitle: choreTitle, choreDescription: choreDescription)
                    )
                }
                .padding()
            }
        }
        .sheet(isPresented: $isPresentingImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { newChoreImage in
                choreImage = newChoreImage
            }
        }
    }
}

struct AddChoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddChoreView(
            addChoreViewModel: ObservableViewModel(
                staticState: AddChoreState()
            ),
            views: Dependency.preview.views()
        )

    }
}

extension Dependency.Views{
    func addChoreView() -> AddChoreView{
        return AddChoreView(
            addChoreViewModel: ObservableViewModel(
                viewModel: viewModels.addChoreViewModel
            ),
            views: self
        )
    }
}
