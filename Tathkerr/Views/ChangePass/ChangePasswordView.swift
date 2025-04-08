//
//  ChangePasswordView.swift
//  Tathaker
//
//  Created by Muhammad Zakir on 01/04/2025.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                if !successMessage.isEmpty {
                    Text(successMessage)
                        .foregroundColor(.green)
                }

                Button(action: changePassword) {
                    Text("Update Password")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#1B365D"))
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .background(Color(hex: "#D6E6F2"))
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }

    func changePassword() {
        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match"
            successMessage = ""
            return
        }

        guard newPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            successMessage = ""
            return
        }

        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                successMessage = ""
            } else {
                successMessage = "Password updated successfully"
                errorMessage = ""
                newPassword = ""
                confirmPassword = ""
                
            
                
            }
        }
    }
}

