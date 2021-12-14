//
//  AddMultimediaNote.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import SwiftUI
import AVFoundation
import Speech

/*
 Difference between fileprivate and private:
 fileprivate --> makes the constant or variable accessible anywhere only inside this source file.
 private     --> makes it accessible only inside the type (e.g., class, struct) that declared it.
 */
fileprivate var audioFullFilename = ""
fileprivate var audioRecorder: AVAudioRecorder!

struct addNote: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    
    @State private var recordingVoice = false //suppose be two
    @State private var recordingVoice1 = false
    @State private var noteTitle = ""
    @State private var note = "Enter text here"
    @State private var photoTakeOrPickIndex = 0
    let photoTakeOrPickChoices = ["Channel 1", "Channel 2"]
    
    var eventCount = [1, 2, 3, 4, 5, 6, 7]
    @State private var selectedCount = 1
    
    @State private var speechConvertedToText = ""
    
    @State private var startDate = Date()
    @State private var startTime = Date()
    @State private var currentDate1 = Date()
    

    @State private var checkResult = true
    
    
    
    // Alerts
    @State private var showMissingInputDataAlert = false
    @State private var showVoiceMemoAddedAlert = false
    
    
    
    var body: some View {
        Form {
            Section(header: Text("Pill name")) {
                HStack {
                    TextField("Enter Pill Name", text: $noteTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.words)
                    
                    // Button to clear the text field
                    Button(action: {
                        self.noteTitle = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    
                }   // End of HStack
            }
            
            
            Section(header: Text("Pill Instructions")) {
                TextEditor(text: $note)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.words)
                    .frame(width: 300.0, height: 100.0)
                    .multilineTextAlignment(.leading)
                
            }
            
            
            Section(header: Text("Start Date")) {
                DatePicker(
                    selection: $startDate,
                    in: Date()...,
                    displayedComponents: .date) {
                    Text("Start Date")
                    }
            }
            
            Section(header: Text("Start Time")) {
                if startDate != currentDate1 {
                DatePicker(selection: $startTime, displayedComponents: .hourAndMinute) {
                    Text("Start Time")
                }
                }
                else {
                    DatePicker(selection: $startTime, in: Date()..., displayedComponents: .hourAndMinute) {
                        Text("Start Time")
                    }
                }
            }

            //Section(header: Text("event Count")) {
              //  VStack {
                //        Picker("Please choose count", selection: $selectedCount) {
                  //          ForEach(eventCount, id: \.self) {
                    //            Text(String($0))
                      //      }
                        //}.pickerStyle(.wheel)
                        //Text("You selected: \(selectedCount)")
                //}
            //}
            
            Section(header: Text("Pick One Channel, Channel 1 is primary")) {
                VStack {
                    Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                        ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                            Text(self.photoTakeOrPickChoices[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                }   // End of VStack
            }
            
            Section(header: Text("check availability")) {
                
                Button("check availability"){
                    checkResult = formCheck()
                }
            }
            
        }   // End of Form
        .font(.system(size: 14))
        .alert(isPresented: $showVoiceMemoAddedAlert, content: { self.noteAddedAlert })
        .navigationBarTitle(Text("New Pill Note"), displayMode: .inline)
        // Place the Add (+) button on right of the navigation bar
        .navigationBarItems(trailing:
                                Button(action: {
                                    
                                    self.saveNewMultimediaNote()
                                    self.showVoiceMemoAddedAlert = true
                                    writeMultimediaNotesDataFile()
                                    uploadData()
                                    checkResult = true
                                    
                                    
                                }) {
                                    Image(systemName: "plus")
                                }.disabled(checkResult))
        
        
        
    }   // End of body
    

    
    
    /*
     ----------------------------------
     MARK: - New Notes Added Alert
     ----------------------------------
     */
    var noteAddedAlert: Alert {
        Alert(title: Text("Instruction Note Added!"),
              message: Text("New Instruction note is added to your Instruction notes list."),
              dismissButton: .default(Text("OK")) {
                
                // Dismiss this Modal View and go back to the previous view in the navigation hierarchy
                self.presentationMode.wrappedValue.dismiss()
              })
    }
    
    /*
     ----------------------------------------
     MARK: - Voice Recording Microphone Label
     ----------------------------------------
     */
    var voiceRecordingMicrophoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    
    /*
     ---------------------------------------
     MARK: Voice Recording Microphone Tapped
     ---------------------------------------
     */
    func voiceRecordingMicrophoneTapped() {
        if audioRecorder == nil {
            self.recordingVoice = true
            startRecording()
        } else {
            self.recordingVoice = false
            finishRecording()
        }
    }
    
    /*
     ----------------------------------
     MARK: - Start Voice Memo Recording
     ----------------------------------
     */
    func startRecording() {
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioFullFilename = UUID().uuidString + ".m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(audioFullFilename)
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilenameUrl, settings: settings)
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    /*
     -----------------------------------
     MARK: - Finish Voice Memo Recording
     -----------------------------------
     */
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        self.recordingVoice = false
    }
    
    
    /*
     -----------------------
     MARK: - Supporting View
     -----------------------
     */
    var microphoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice1 ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
            Text(recordingVoice1 ? "Recording your voice... Tap to Stop!" : "Convert Speech to Text!")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
    
    /*
     -------------------------
     MARK: - Microphone Tapped
     -------------------------
     */
    func microphoneTapped() {
        if recordingVoice1 {
            cancelRecording()
            self.recordingVoice1 = false
        } else {
            self.recordingVoice1 = true
            recordAndRecognizeSpeech()
        }
    }
    
    /*
     ------------------------
     MARK: - Cancel Recording
     ------------------------
     */
    func cancelRecording() {
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask.finish()
    }
    
    /*
     ----------------------------------------------
     MARK: - Record Audio and Transcribe it to Text
     ----------------------------------------------
     */
    func recordAndRecognizeSpeech() {
        //--------------------
        // Set up Audio Buffer
        //--------------------
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        //---------------------
        // Prepare Audio Engine
        //---------------------
        audioEngine.prepare()
        
        //-------------------
        // Start Audio Engine
        //-------------------
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start Audio Engine!")
            return
        }
        
        //-------------------------------
        // Convert recorded voice to text
        //-------------------------------
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
            
            if result != nil {  // check to see if result is empty (i.e. no speech found)
                if let resultObtained = result {
                    let bestString = resultObtained.bestTranscription.formattedString
                    self.speechConvertedToText = bestString
                    
                } else if let error = error {
                    print("Transcription failed, but will continue listening and try to transcribe. See \(error)")
                }
            }
        })
    }
    
    /*
     --------------------------
     MARK: - Add New Notes
     --------------------------
     */
    func saveNewMultimediaNote() {
        
        // Instantiate a Date object
        let date = Date()
        
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        
        // Set the date format to yyyy-MM-dd at HH:mm:ss
        dateFormatter.dateFormat = "yyyy-MM-dd' at 'HH:mm:ss"
        
        // Format the Date object as above and convert it to String
        let currentDateTime = dateFormatter.string(from: date)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let startdate = dateFormatter1.string(from: startDate)
        
        let timeFormatter1 = DateFormatter()
        timeFormatter1.dateFormat = "HH:mm:ss"
        let starttime = timeFormatter1.string(from: startTime)
        
        let timeFormatter2 = DateFormatter()
        timeFormatter2.dateFormat = "HH:mm"
        let startTime2 = timeFormatter2.string(from: startTime)
        
        
        
        let checkuse = startdate + "T" + startTime2 + "+00:00"
        
        let schedule = startdate + "T" + starttime + "+00:00"
        
        

        
        let newMultimediaNote = saveNotePhoto(title: noteTitle, textualNote: note, audioFullFilename: audioFullFilename, dataTime: currentDateTime, startDate: startdate, startTime: starttime, eventCount: String(selectedCount), label: photoTakeOrPickChoices[photoTakeOrPickIndex], schedule: schedule, checkuse: checkuse)
        
        userData.multimediaNotesStructList.append(newMultimediaNote)
        
        
        
        multimediaNoteStructList = userData.multimediaNotesStructList
        
        audioFullFilename = ""
        self.presentationMode.wrappedValue.dismiss()
        
        

    }
    
    func formCheck() -> Bool {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter1.string(from: startDate)
        
        let timeFormatter2 = DateFormatter()
        timeFormatter2.dateFormat = "HH:mm"
        let startTime2 = timeFormatter2.string(from: startTime)
        
        
        
        let checkuse = startDate + "T" + startTime2 + "+00:00"
        
        return checkReady(deliveryTime: checkuse, channel: photoTakeOrPickChoices[photoTakeOrPickIndex])
    }
}


