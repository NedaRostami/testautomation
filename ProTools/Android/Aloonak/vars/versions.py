class Version:

    variables = {}

    def __init__(self):
        self.app_package = 'com.protoolsmobileapp.debug'
        self.variables.update(
            APP_PACKAGE=self.app_package,
            HOME_ACTIVITY='com.protoolsmobileapp.MainActivity',
            SPLASH_ACTIVITY='com.protoolsmobileapp.MainActivity',
            AUTOMATION_NAME='UiAutomator2',
            PLATFORM_NAME_ANDROID='Android',
            DEVICE_ORIENTATION='portrait',
            PRO_STAGING_BUTTON=self.app_package + ':id/fragmentDebugStaging',
            STAGING_BUTTON='accessibility_id=staging-env-button',
            LOCATION_SPINNER_LOCATOR=f'android=UiScrollable(UiSelector().scrollable(true).instance(0)).scrollIntoView(new UiSelector().resourceId("{self.app_package}:id/fragmentPostAdLocation").childSelector(new UiSelector().className("android.widget.FrameLayout")))',
            Mail_Number='accessibility_id=getPhoneInput',
            Confirm_Digit='accessibility_id=submitCode',
            )

    @staticmethod
    def not_found():
        raise Exception('Could not find requested version')

class V1_18(Version):
    def __init__(self):
        super().__init__()

class V1_20_2(V1_18):
    def __init__(self):
        super().__init__()
