//
//  LocalizableString.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit

// MARK: - Common
let TITLE_CANCEL = NSLocalizedString("Cancel", comment: "")
let TITLE_SAVE = NSLocalizedString("Save", comment: "")
let TITLE_ERROR = NSLocalizedString("Error", comment: "")
let TITLE_DELETE = NSLocalizedString("Delete", comment: "")
let TITLE_EDIT = NSLocalizedString("Edit", comment: "")
let TITLE_MENU = NSLocalizedString("Menu", comment: "")
let MESSAGE_DELETE_INPUT = NSLocalizedString("DeleteInput", comment: "")
let MESSAGE_SERVER_COMMUNICATION = NSLocalizedString("ServerCommunicationMessage", comment: "")

// MARK: - TabPage
let TITLE_LIST = NSLocalizedString("List", comment: "")
let TITLE_MAP = NSLocalizedString("Map", comment: "")

// MARK: - Color
let TITLE_COLOR = NSLocalizedString("Color", comment: "")
let TITLE_RED = NSLocalizedString("Red", comment: "")
let TITLE_PINK = NSLocalizedString("Pink", comment: "")
let TITLE_ORANGE = NSLocalizedString("Orange", comment: "")
let TITLE_YELLOW = NSLocalizedString("Yellow", comment: "")
let TITLE_GREEN = NSLocalizedString("Green", comment: "")
let TITLE_BLUE = NSLocalizedString("Blue", comment: "")
let TITLE_PURPLE = NSLocalizedString("Purple", comment: "")
let TITLE_GRAY = NSLocalizedString("Gray", comment: "")
let TITLE_WHITE = NSLocalizedString("White", comment: "")
let TITLE_BLACK = NSLocalizedString("Black", comment: "")

// MARK: - Task
let TITLE_TITLE = NSLocalizedString("Title", comment: "")
let TITLE_MEMO = NSLocalizedString("Memo", comment: "")
let TITLE_IMPORTANCE = NSLocalizedString("Importance", comment: "")
let TITLE_URGENCY = NSLocalizedString("Urgency", comment: "")
let TITLE_1to8 = NSLocalizedString("1to8", comment: "")
let TITLE_TASK_TYPE = NSLocalizedString("taskType", comment: "")
let TITLE_DEADLINE_DATE = NSLocalizedString("DeadlineDate", comment: "")
let TITLE_REPEAT = NSLocalizedString("Repeat", comment: "")
let TITLE_ADD_TASK = NSLocalizedString("AddTaskTitle", comment: "")
let TITLE_DELETE_TASK = NSLocalizedString("DeleteTaskTitle", comment: "")
let MESSAGE_DELETE_TASK = NSLocalizedString("DeleteTaskMessage", comment: "")
let TITLE_COMPLETE_TASK = NSLocalizedString("CompleteTaskTitle", comment: "")
let MESSAGE_COMPLETE_TASK = NSLocalizedString("CompleteTaskMessage", comment: "")
let MESSAGE_INCOMPLETE_TASK = NSLocalizedString("InCompleteTaskMessage", comment: "")
let MESSAGE_ZERO_TASK = NSLocalizedString("ZeroTaskMessage", comment: "")
let TITLE_COMPLETE_TASK_LIST = NSLocalizedString("CompleteTaskListTitle", comment: "")
let TITLE_TASK_LIST = NSLocalizedString("TaskList", comment: "")
let TITLE_UPDATE_URGENCY = NSLocalizedString("UpdateUrgency", comment: "")
let TITLE_AUTO_UPDATE_URGENCY = NSLocalizedString("AutoUpdateUrgencyTitle", comment: "")
let MESSAGE_UPDATE_URGENCY = NSLocalizedString("AutoUpdateUrgencyMessage", comment: "")

// MARK: - Filter
let TITLE_FILTER = NSLocalizedString("Filter", comment: "")

// MARK: - SettingViewController
let TITLE_SETTING = NSLocalizedString("Setting", comment: "")
let TITLE_BASIC_CONFIGURATION = NSLocalizedString("Basic configuration", comment: "")
let TITLE_DATA = NSLocalizedString("Data", comment: "")
let TITLE_HELP = NSLocalizedString("Help", comment: "")
let TITLE_THEME = NSLocalizedString("Theme", comment: "")
let TITLE_NOTIFICATION = NSLocalizedString("Notification", comment: "")
let TITLE_DATA_TRANSFER = NSLocalizedString("Data transfer", comment: "")
let TITLE_HOW_TO_USE_THIS_APP = NSLocalizedString("How to use this App?", comment: "")
let TITLE_INQUIRY = NSLocalizedString("Inquiry", comment: "")
let TITLE_SUCCESS = NSLocalizedString("Success", comment: "")
let MESSAGE_INTERNET_ERROR = NSLocalizedString("Internet Error", comment: "")
let MESSAGE_MAILER_ERROR = NSLocalizedString("Mailer Error", comment: "")
let TITLE_MAIL_SUBJECT = NSLocalizedString("Mail Subject", comment: "")
let TITLE_MAIL_MESSAGE = NSLocalizedString("Mail Message", comment: "")
let MESSAGE_MAIL_SEND_SUCCESS = NSLocalizedString("Mail Send Success", comment: "")
let MESSAGE_MAIL_SEND_FAILED = NSLocalizedString("Mail Send Failed", comment: "")

// MARK: - LoginViewController
let TITLE_LOGIN_HELP = NSLocalizedString("LoginHelp", comment: "")
let TITLE_ALREADY_LOGIN = NSLocalizedString("AlreadyLogin", comment: "")
let TITLE_MAIL_ADDRESS = NSLocalizedString("MailAddress", comment: "")
let TITLE_PASSWORD = NSLocalizedString("Password", comment: "")
let TITLE_LOGIN = NSLocalizedString("Login", comment: "")
let TITLE_LOGOUT = NSLocalizedString("Logout", comment: "")
let TITLE_FORGOT_PASSWORD = NSLocalizedString("Forgot password", comment: "")
let TITLE_CREATE_ACCOUNT = NSLocalizedString("Create account", comment: "")
let TITLE_DELETE_ACCOUNT = NSLocalizedString("Delete account", comment: "")
let MESSAGE_EMPTY_TEXT_ERROR = NSLocalizedString("EmptyTextError", comment: "")
let MESSAGE_EMPTY_TEXT_ERROR_PASSWORD_RESET = NSLocalizedString("EmptyTextErrorPasswordReset", comment: "")
let MESSAGE_DURING_LOGIN_PROCESS = NSLocalizedString("DuringLoginProcess", comment: "")
let MESSAGE_LOGIN_SUCCESSFUL = NSLocalizedString("LoginSuccessful", comment: "")
let MESSAGE_INVALID_EMAIL = NSLocalizedString("InvalidEmail", comment: "")
let MESSAGE_WRONG_PASSWORD = NSLocalizedString("WrongPassword", comment: "")
let MESSAGE_LOGIN_ERROR = NSLocalizedString("LoginError", comment: "")
let MESSAGE_LOGOUT_SUCCESSFUL = NSLocalizedString("LogoutSuccessful", comment: "")
let MESSAGE_LOGOUT_ERROR = NSLocalizedString("LogoutError", comment: "")
let TITLE_PASSWORD_RESET = NSLocalizedString("PasswordResetTitle", comment: "")
let MESSAGE_PASSWORD_RESET = NSLocalizedString("PasswordResetMessage", comment: "")
let MESSAGE_MAIL_SEND_ERROR = NSLocalizedString("MailSendError", comment: "")
let MESSAGE_MAIL_SEND_SUCCESSFUL = NSLocalizedString("MailSendSuccessful", comment: "")
let MESSAGE_CREATE_ACCOUNT = NSLocalizedString("CreateAccountMessage", comment: "")
let MESSAGE_DURING_CREATE_ACCOUNT_PROCESS = NSLocalizedString("DuringCreateAccountProcess", comment: "")
let MESSAGE_EMAIL_ALREADY_INUSE = NSLocalizedString("EmailAlreadyInUse", comment: "")
let MESSAGE_WEAK_PASSWORD = NSLocalizedString("WeakPassword", comment: "")
let MESSAGE_CREATE_ACCOUNT_ERROR = NSLocalizedString("CreateAccountError", comment: "")
let MESSAGE_DATA_TRANSFER_SUCCESSFUL = NSLocalizedString("DataTransferSuccessful", comment: "")
let MESSAGE_DELETE_ACCOUNT = NSLocalizedString("DeleteAccountMessage", comment: "")
let MESSAGE_PLEASE_LOGIN = NSLocalizedString("PleaseLogin", comment: "")
let MESSAGE_DURING_DELETE_ACCOUNT = NSLocalizedString("DuringDeleteAccount", comment: "")
let MESSAGE_DELETE_ACCOUNT_SUCCESSFUL = NSLocalizedString("DeleteAccountSuccessful", comment: "")
let MESSAGE_DELETE_ACCOUNT_ERROR = NSLocalizedString("DeleteAccountError", comment: "")

// MARK: - ErrorMessage
let ERROR_MESSAGE_EMPTY_TITLE = NSLocalizedString("EmptyTitle", comment: "")
let ERROR_MESSAGE_SAVE_FAILED = NSLocalizedString("SaveFailed", comment: "")
