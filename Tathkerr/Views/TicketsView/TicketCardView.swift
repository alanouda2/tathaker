//
//  TicketCardView.swift
//  Tathaker
//
//  Created by Muhammad Zakir on 01/04/2025.
//
import SwiftUI

struct TicketCardView: View {
    let ticket: BookedTicket

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text("Congrats")
                        .bold()
                    Text("Your ticket has been successfully booked")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Event")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(ticket.eventTitle)
                    .font(.headline)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(ticket.bookingTime)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Tickets")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("×\(ticket.quantity)")
                    }
                }
            }

            Divider()

            VStack {
                Image("qr") // Replace with real barcode if available
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Text("1524653678")
                    .font(.caption)
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}
