/*
 * AppSettings.cpp
 *
 *  Created on: 16 oct. 2014
 *      Author: pierre
 */


#include "SettingsController.hpp"
#include "ConversationMAnager.hpp"
#include <QRegExp>
#include "XMPPService.hpp"

bool SettingsController::m_LogEnabled = false;


SettingsController::SettingsController(QObject *parent) : QObject(parent), m_FontSize(28), m_Settings(NULL) {

    m_User = ConversationManager::get()->getUser();
    m_Avatar = ConversationManager::get()->getAvatar();
    m_Settings = new QSettings("Amonchakai", "Hg10");

    m_Theme = m_Settings->value("theme").value<int>();
    m_FontSize = m_Settings->value("fontSize").value<int>();
    if(m_FontSize == 0)
        m_FontSize = 28;
    m_LogEnabled = m_Settings->value("logsEnabled", false).toBool();

    QRegExp isFacebook("(.*)@chat.facebook.com");
    if(isFacebook.indexIn(m_User) != -1)
        m_IsGoogleEnabled = false;
    else
        m_IsGoogleEnabled = true;

    m_DropBoxEnabled = m_Settings->value("DropBoxEnabled", false).toBool();

    bool check = connect(ConversationManager::get(), SIGNAL(avatarUpdated()), this, SLOT(updateAvatar()));

    Q_ASSERT(check);
    Q_UNUSED(check);

}

bool SettingsController::getGoogleLogged() {
    return !m_Settings->value("access_token").toString().isEmpty();
}


void SettingsController::updateAvatar() {
    setAvatar(ConversationManager::get()->getAvatar());
    setUserName(ConversationManager::get()->getUser());

    QRegExp isFacebook("(.*)@chat.facebook.com");
    if(isFacebook.indexIn(ConversationManager::get()->getUser()) != -1)
        setEnableGoogle(false);

}


void SettingsController::save() {
    m_Settings->setValue("theme", m_Theme);
    m_Settings->setValue("fontSize", m_FontSize);
    m_Settings->setValue("logsEnabled", m_LogEnabled);
    m_Settings->setValue("DropBoxEnabled", m_DropBoxEnabled);

    XMPP::get()->notifySettingChange();
}

