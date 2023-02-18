//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Антон Шалимов on 13.02.2023.
//

import UIKit

protocol AddRegistrationViewControllerDelegate: AnyObject {
    func addRegistrationViewController(_ controller: AddRegistrationTableViewController, didSave registration: Registration)
}

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    // MARK: Implementing necessary delegate methods
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    // MARK: Properties
    
    weak var delegate: AddRegistrationViewControllerDelegate?
    var roomType: RoomType?
    var initialRegistration: Registration?
    
    init?(coder: NSCoder, registration: Registration? = nil) {
        self.initialRegistration = registration
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Computed property to store registration data
    var registration: Registration? {
        // If room type is set not set -> return nil, otherwise fill and return registration struct
        guard let roomType = self.roomType else { return nil }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let wifiEnabled = wifiSwitch.isOn
        
        return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wifi: wifiEnabled, roomType: roomType)
    }
    
    // MARK: Initial variables and constants
    
    /// 3 following properties stores index path of the date pickers in a table
    let checkInDatePickerCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let testWheelDatePickerIndexPath = IndexPath(row: 2, section: 1)
    let datesLabels = IndexPath(row: 3, section: 1)
    
    /// 3 following properties indicates if date pickers for check in/out are visible or not
    /// When properties is set (for example by default it sets to false) than the `isHidden` prop of a picker will set also
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    var isTestWheelDatePickerIndexPathVisible: Bool = false {
        didSet {
            testWheelDatePicker.isHidden = !isTestWheelDatePickerIndexPathVisible
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting a check in date picker current and minimum date to today
        
        let todayDate = Calendar.current.startOfDay(for: Date())
        if (initialRegistration != nil) {
            firstNameTextField.text = initialRegistration?.firstName
            lastNameTextField.text = initialRegistration?.lastName
            emailTextField.text = initialRegistration?.emailAddress

            checInDatePicker.date = initialRegistration!.checkInDate
            checkOutDatePicker.date = initialRegistration!.checkInDate
            checkInDateLabel.text = initialRegistration?.checkInDate.formatted(date: .abbreviated, time: .omitted)
            checkOutDateLabel.text = initialRegistration?.checkOutDate.formatted(date: .abbreviated, time: .omitted)

            numberOfAdultsLabel.text = String(initialRegistration!.numberOfAdults)
            numberOfChildrenLabel.text = String(initialRegistration!.numberOfChildren)
            numberOfAdultsStepper.value = Double(initialRegistration!.numberOfAdults)
            numberOfChildrenStepper.value = Double(initialRegistration!.numberOfChildren)

            wifiSwitch.isOn = initialRegistration!.wifi

            roomType = initialRegistration?.roomType

        } else {
            checInDatePicker.date = todayDate
            checInDatePicker.minimumDate = todayDate
            checkInDateLabel.text = todayDate.formatted(date: .abbreviated, time: .omitted)
            checkOutDateLabel.text = todayDate.formatted(date: .abbreviated, time: .omitted)
        }
        
        checInDatePicker.date = todayDate
        checInDatePicker.minimumDate = todayDate
        checkInDateLabel.text = todayDate.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = todayDate.formatted(date: .abbreviated, time: .omitted)
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Outlets
    
    // Personal info outlets
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    // Check in/out dates outlets
    @IBOutlet var checInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var testWheelDatePicker: UIDatePicker!
    
    // Amount of people outlets
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    // Services outlets
    @IBOutlet var wifiSwitch: UISwitch!
    
    // Room selection outlets
    @IBOutlet var roomTypeLabel: UILabel!
    
    
    // MARK: Actions
    
    /// Check in date picker "on change" handler
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Function to update people section views when stepper values changed
    /// - Parameter sender: sender shoul be UIStepper to link two steppers together
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    
    /// Action for managing switch state changing for wifi
    /// - Parameter sender: sender set to switch
    @IBAction func wifiSwitchValueChanged(_ sender: UISwitch) {
    }
    
    // MARK: Functions
    
    func updateDateViews() {
        /* Parse day, that user selected in check in date picker and
         set check out minimum date to time delta + 1 day*/
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checInDatePicker.date)
        checkInDateLabel.text = checInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    /// Function for synchronizing the views and any time stepper value changes
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    /// Function for updating the room types label
    func updateRoomType() {
        // If room type is selected (property initialized)
        if let roomType = roomType {
            // Set the room type label text to room type name
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not set"
        }
    }
    
    // MARK: Overiiding table view delegate methods
    
    /// This override of delegate method is for setting the heigh of the datePicker objects, if they are not selected
    /// - Parameters:
    ///   - tableView: tableView object
    ///   - indexPath: index path for concrete rows in table
    /// - Returns:
    ///   - 0 if index path correlates with the datepicker rows if they are not shown;
    ///   - automaticDimensions for every other table rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case testWheelDatePickerIndexPath where isTestWheelDatePickerIndexPathVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    /// This override of delegate method is for setting up the height of the date picker rows when they are supposed to show full date picker height
    /// - Parameters:
    ///   - tableView: tableView object
    ///   - indexPath: Index path for concrete rows in table
    /// - Returns:
    ///   - 190 if datepicker rows are selected
    ///   - automaticDimensions for every other row in table
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case testWheelDatePickerIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    /// Overriding table view delegate method for selecting row to play with test wheel datepicker visibility
    /// - Parameters:
    ///   - tableView: tableView object
    ///   - indexPath: indexPath of row, that user selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row after user touches it
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        // If user taps the labels with check in and check out dates and the visibility of wheel DP is false
        if indexPath == datesLabels && isTestWheelDatePickerIndexPathVisible == false {
            // Show the date picker
            isTestWheelDatePickerIndexPathVisible.toggle()
            // Otherwise if either datepicker is already shown or user selects other row
        } else if indexPath != datesLabels && isTestWheelDatePickerIndexPathVisible {
            // Close the date picker
            isTestWheelDatePickerIndexPathVisible.toggle()
            // If any other cases - close the wheel datepicker
        } else {
            isTestWheelDatePickerIndexPathVisible = false
        }
        // Following section is done to recalculate the row height for each row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // editRegistrationSegue
    }
    
    // MARK: Segues actions
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        // Объявляем константу с объектом типа таблицы выбора типа комнаты
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        // Тут мы по сути говорим этому объекту, что получаетелем его данных (сообщений) является этот ViewController
        selectRoomTypeController?.delegate = self
        // Тут мы присваиваем VC выбора типа комнаты значение, которое было или не было установлено в нем до этого. Т.е. если мы уже выбирали какой-то тип комнаты до этого, то при переходе в VC выбора команты он будет отмечен. Если нет, то отмечено ничего не будет
        selectRoomTypeController?.roomType = self.roomType
        // Осуществление перехода в VC выбора комнат
        return selectRoomTypeController
    }
    
}
