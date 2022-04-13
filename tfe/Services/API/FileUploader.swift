//
//  StrvUploader.swift
//  tfe
//
//  Created by martin d'hoedt on 4/13/22.
//

import Foundation
import Combine

enum UploadResponse {
    case progress(percentage: Double)
    case response(data: Data?)
}

class FileUploader: NSObject {
    
    let progress: PassthroughSubject<(id: Int, progress: Double), Never> = .init()
    lazy var session: URLSession = {
        .init(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    func upload(fileUrl: URL, apiUrl: URL) -> AnyPublisher<UploadResponse, Error> {
        
        let subject: PassthroughSubject<UploadResponse, Error> = .init()
        let session = URLSession.shared
        
        let pointcloudData : Data?
        do {
            pointcloudData = try Data(contentsOf: fileUrl)
        } catch(let error) {
            return Fail(error: ApiError.invalidRequest("Data error :\n\(error)"))
                .eraseToAnyPublisher()
        }
        
        let boundary = UUID().uuidString
        let fileName = fileUrl.deletingPathExtension().lastPathComponent
        let bodyData = NetworkingManager.createFormdataBodyData(data: pointcloudData!, boundary:boundary, fileName:fileName)
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        // headers
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        request.setValue(
            "gzip, deflate",
            forHTTPHeaderField: "Accept-Encoding")
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept")
        request.setValue(
            "\(bodyData)",
            forHTTPHeaderField: "Content-Length"
        )
        
        let task: URLSessionUploadTask = session.uploadTask(
            with: request,
            from: bodyData
        ) { data, response, error in
            if let error = error {
                print("error : \(error)")
                subject.send(completion: .failure(error))
                return
            }
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                print("response : \(response?.description ?? "")")
                subject.send(.response(data: data))
                return
            }
            print("task continues")
            subject.send(.response(data: nil))
        }
        task.resume()
        
        return progress
            .filter{ $0.id == task.taskIdentifier }
            .setFailureType(to: Error.self)
            .map { .progress(percentage: $0.progress) }
            .merge(with: subject)
            .eraseToAnyPublisher()
    }
}

extension FileUploader: URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        print("progress : \(task.progress.fractionCompleted)")
        progress.send((
            id: task.taskIdentifier,
            progress: task.progress.fractionCompleted
        ))
    }
}
