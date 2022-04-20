//
//  StrvUploader.swift
//  tfe
//
//  Created by martin d'hoedt on 4/13/22.
//
// thanks to : https://stackoverflow.com/a/59875552

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
        if (!Reachability.isConnectedToNetwork()) {
            return Fail(error: ApiError.noInternetAccess(""))
                .eraseToAnyPublisher()
        }
        
        let pointcloudData : Data?
        do {
            pointcloudData = try Data(contentsOf: fileUrl)
        } catch(let error) {
            return Fail(error: ApiError.invalidRequest("Data error :\n\(error)"))
                .eraseToAnyPublisher()
        }
        
        let boundary = UUID().uuidString
        let fileName = fileUrl.lastPathComponent
        let bodyData = FileUploader.createFormdataBodyData(data: pointcloudData!, boundary:boundary, fileName:fileName)
        
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
            "\(bodyData.count)",
            forHTTPHeaderField: "Content-Length"
        )
        
        let subject: PassthroughSubject<UploadResponse, Error> = .init()
        let session = URLSession.shared
        
        let task: URLSessionUploadTask = session.uploadTask(
            with: request,
            from: bodyData
        ) { data, response, error in
            if let error = error {
                print("[URLSessionUploadTask] Error : \(error)")
                subject.send(completion: .failure(error))
                return
            }
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                print("[URLSessionUploadTask] Response : \(response?.description ?? "")")
                subject.send(.response(data: data))
                return
            }
            print("[URLSessionUploadTask] task continues")
            subject.send(.response(data: nil))
        }
        task.resume()
        
        return progress
            .filter{ $0.id == task.taskIdentifier }
            .setFailureType(to: Error.self)
            .print("upload task :")
            .map { .progress(percentage: $0.progress) }
            .merge(with: subject)
            .eraseToAnyPublisher()
    }
    
    static func createFormdataBodyData(data: Data, boundary: String, fileName: String) -> Data {
        var fullData = Data()
        
        fullData.append(
            "--\(boundary)\r\n".data(using: .utf8)!
        )
        fullData.append(
            "Content-Disposition: form-data; name=\"georeferenced\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!
        )
        fullData.append(
            "Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!
        )
        fullData.append(
            data
        )
        fullData.append(
            "\r\n--\(boundary)--\r\n".data(using: .utf8)!
        )
        
        return fullData
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
