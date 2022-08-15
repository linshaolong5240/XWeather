//
//  FileExportHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileExportDemo: View {
    @State private var showExporter = false
    @State private var showExporterButton = true
    @State private var exportImage: CrossImage?
    @State private var exportImageSize = CGSize(width: 1024, height: 1025)
    
    var body: some View {
        ZStack {
            Circle().fill(Color.pink)
            VStack {
                if showExporterButton {
                    Button {
                        exportImage = self.frame(width: exportImageSize.width, height: exportImageSize.height).snapshot()
                        showExporter.toggle()
                    } label: {
                        Text("showExporter")
                    }
                }
                Spacer()
            }
        }
        .fileExporter(isPresented: $showExporter, document: ImageFileDocument(image: exportImage), contentType: .png) { result in
            switch result {
            case .success(let url):
                print("fileExporter success: \(url)")
            case .failure(let error):
                print("fileExporter failure: \(error.localizedDescription)")
            }
        }
    }
}

#if DEBUG
struct FileExportHelper_Previews: PreviewProvider {
    static var previews: some View {
        FileExportDemo()
    }
}
#endif


struct ImageFileDocument: FileDocument {

    static var readableContentTypes: [UTType] { [.png] }

    var image: CrossImage

    init(image: CrossImage?) {
        self.image = image ?? CrossImage()
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let image = CrossImage(data: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.image = image
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = image.pngData() else {
            throw CocoaError(.fileWriteUnknown)
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
