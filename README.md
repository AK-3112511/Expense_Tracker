# Expense Tracker

Expense Tracker App helps you manage expenses by category, view them in a list, and visualize spending through bar and pie charts. It also lets you filter and analyze expenses by custom date ranges.

## 📲 Download APK
👉 [Download the latest APK here](https://github.com/AK-3112511/Expense_Tracker/releases/download/v1.0.0/app-release.apk)

## 📌 Features
- Add expenses with category selection  
- View all expenses in a structured list  
- Visualize spending through bar and pie charts  
- Filter expenses by custom date range  
- Get a clear overview of your spending patterns

## 📸 App Preview  

### 🏁 Start Screen  
![Starting_screen](https://github.com/user-attachments/assets/71cb162d-a524-49df-9d53-0f8198de4f23)

### ❓ Adding New Expense  
![Adding new expense](https://github.com/user-attachments/assets/6e580e61-fa6d-4279-84a7-6b72efa3d45f)

### 🏆 Representation in Bar chart  
![Representation of expenses in bar chart](https://github.com/user-attachments/assets/1f558625-8a19-4a5f-a2fe-89fb42f8e312)

### 🏆 Representation in Pie chart  
![Representation of expenses in pie chart](https://github.com/user-attachments/assets/0279f618-8930-483d-ac1a-2568ea82f68e)

### 🏆 Filter options 
![Filter options](https://github.com/user-attachments/assets/65e6b689-04f5-4877-8b90-d07329c7710e)

### 🏆 Expense in selected date range 
![Expenses in selected date range](https://github.com/user-attachments/assets/0f8cd1ba-dd1c-44d3-87b7-cadea49cd4ed)


## 📂 Project Structure
lib/
├── models/
│ ├── date_filter.dart
│ └── expense.dart
│
├── widget/
│ ├── chart/
│ │ ├── chart_bar.dart
│ │ ├── chart.dart
│ │ └── pie_chart.dart
│ │
│ ├── expenses_list/
│ │ ├── expenses_item.dart
│ │ └── expenses_list.dart
│ │
│ ├── date_range_selector.dart
│ ├── expenses.dart
│ └── new_expense.dart
│
├── main.dart
└── txt.dart

## 🧑‍💻 Installation & Setup

Follow these steps to run the project locally:

1. Clone the repository
   git clone https://github.com/your-username/expense-tracker.git
2.Navigate to the project folder
  cd expense-tracker
3.Get Flutter dependencies
  flutter pub get
4.Run the application
  flutter run

👉 Make sure you have Flutter installed and set up on your system.
👉 You can run the app on an emulator or a connected physical device.
✅ This section covers everything needed to set up and run the app locally.  
🔸 Replace `your-username` in the `git clone` command with your actual GitHub username.

## 🛠️ Tech Stack
- Flutter  
- Dart

## 📄 License
This project is licensed under the MIT License.
