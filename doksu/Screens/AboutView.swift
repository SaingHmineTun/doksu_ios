import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 18) {
                    BundleImage(name: "tmklogo")
                        .frame(maxHeight: 250)
                        .padding(.top, 12)

                    VStack(spacing: 0) {
                        AboutRow(imageName: "ic_music", label: "သဵင်ၵႂၢမ်း : ", value: "ၵေႃလိၵ်ႈလၢႆးလႄႈ ၽိင်ႈငႄႈတႆး၊\nၸေႊဝဵင်းမူႇၸေႊ။") {
                            openFacebookPage("100087937960730")
                        }

                        Divider().padding(.leading, 58)

                        AboutRow(imageName: "ic_gmail", label: "ဢီးမေးလ် : ", value: "tmk.muse@gmail.com") {
                            if let url = URL(string: "mailto:tmk.muse@gmail.com") {
                                openURL(url)
                            }
                        }

                        Divider().padding(.leading, 58)

                        AboutRow(systemName: "f.circle.fill", label: "ၾဵတ်ႉပုၵ်ႉ : ", value: "ထုင်ႉမၢဝ်းၶမ်း") {
                            openFacebookPage("61569069823862")
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    
                    Text("Version 1.0.0")
                        .font(.custom(DokSuFonts.namteng, size: 18))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 18)
                }
                .padding(.horizontal, 0)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("လွင်ႈၽူႈၶူင်သၢင်ႈ")
                    .font(.custom(DokSuFonts.ajKunheing, size: 26))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
    }

    private func openFacebookPage(_ id: String) {
        if let url = URL(string: "https://www.facebook.com/profile.php?id=\(id)") {
            openURL(url)
        }
    }
}
