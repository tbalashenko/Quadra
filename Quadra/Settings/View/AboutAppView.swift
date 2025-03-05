//
//  HowToUseTheAppView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 05/03/2025.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Forgetting Curve Section
                Text("**Forgetting Curve**")
                    .font(.title2)
                
                Image("aboutApp-0")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                
                Text("""
                Here is the **Forgetting Curve**, which illustrates how information is lost when there is no effort to retain it.
                
                According to Ebbinghaus’s 1885 work *Über das Gedächtnis*, approximately **60% of learned information is forgotten within the first hour**. After 10 hours, only **35% remains**. By the sixth day, about **20% is retained**, which stays consistent over a month.

                Ebbinghaus also discovered that **spaced repetition** significantly reduces forgetting.
                """)

                // Spaced Repetition Section
                Image("aboutApp-1")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                
                Text("""
                The app includes an **algorithm for spaced repetition**, but success depends on **your engagement**.

                ✅ **Enable reminders** in the app (Settings → Notifications) to stay consistent.
                """)

                // Picture Superiority Effect
                Image("aboutApp-2")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)

                Text("**Picture Superiority Effect**")
                    .font(.title2)
                
                Text("""
                The *Picture Superiority Effect* shows that **images help memory retention** better than words alone.

                📺 If you watch TV shows, **add a screenshot with subtitles**.
                📌 If you find an interesting idiom, **search for more examples online**.
                🎨 If nothing exists, **create your own association with an image**.
                🔍 Still unsure? **Use Google Ngram**—maybe the phrase isn’t even worth memorizing.
                """)

                // Key Recommendations
                Text("**A Few Key Recommendations:**")
                    .font(.title2)

                Text("""
                ✅ The phrase should **spark interest** and feel engaging.  
                ✅ It **shouldn’t be overly complex**.  
                ✅ It may contain familiar words, but should be phrased in a **new and useful way**.
                """)

                // Prosody Section
                Text("**Important! Pronounce Everything Aloud**")
                    .font(.title2)
                
                Text("""
                **Prosody** is the "music" of language. It includes pitch variations that improve speech fluency and comprehension.

                Examples:
                🇺🇸 In **American English**, pitch rises at the end of a question.
                🇷🇺 In **Russian** and **British English**, pitch often falls at the end.
                🇲🇽 **Mexican Spanish** has dramatic pitch shifts.
                🇯🇵 **Japanese** has a controlled pitch, where tone can even change meanings.

                **Prosody helps you:**
                ✔ Understand speech **even if words are muffled**.  
                ✔ **Sound more fluent** and natural to native speakers.  
                ✔ **Be understood more easily** by others.  
                ✔ **Appear more skilled**, even to non-native speakers.
                """)

                // Why This Works
                Text("**Why Does This Work?**")
                    .font(.title2)

                Text("""
                - **A well-chosen image** will make phrases **stick** in your memory.  
                - **Prosody training** improves both **listening and speaking**.  
                - **Spaced repetition** ensures the phrase is **ready when you need it most**.
                """)

                // Recommended Books
                Text("**Recommended Books**")
                    .font(.title2)

                Text("""
                📖 **Atomic Habits** – Learn to integrate repetition into your routine effectively.  
                📖 **Why We Sleep** – Discover why sleep is **critical for memory and learning**.  
                📖 **A Mind for Numbers** – Master learning strategies, focus techniques, and memory hacks.  
                📖 **Learn Like a Pro** (Free course on **edX.org**) – Science-backed methods for **becoming a better learner**.
                """)

                Spacer()
            }
            .padding()
        }
        .background(Color.element)
        .navigationTitle("About the App")
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    AboutAppView()
}

