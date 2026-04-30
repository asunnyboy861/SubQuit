import SwiftUI

struct ContactSupportView: View {
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription Issue", "Cancellation Help", "Other"]
    private let backendURL = "https://feedback-board.iocompile67692.workers.dev"

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
            }

            Section("Your Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 100)
            }

            Section {
                Button {
                    submitFeedback()
                } label: {
                    if isSubmitting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    name = ""
                    email = ""
                    message = ""
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        guard !email.isEmpty, !message.isEmpty else { return }
        isSubmitting = true

        let body: [String: Any] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message
        ]

        guard let url = URL(string: backendURL) else {
            isSubmitting = false
            alertMessage = "Invalid server URL"
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    alertMessage = "Message sent successfully! We'll get back to you soon."
                } else {
                    alertMessage = "Something went wrong. Please try again."
                }
                showAlert = true
            }
        }.resume()
    }
}
