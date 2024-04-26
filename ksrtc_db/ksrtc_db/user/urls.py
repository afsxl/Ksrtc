from django.urls import path
from . import views

urlpatterns = [
    path("userCheckLogin", views.userCheckLogin),
    path("userCheckUsername", views.userCheckUsername),
    path("userSignup", views.userSignup),
    path("userSignupResend", views.userSignupResend),
    path("userGetProfile", views.userGetProfile),
    path("userForgotPassword", views.userForgotPassword),
    path("userOtpCheck", views.userOtpCheck),
    path("userForgotPasswordChange", views.userForgotPasswordChange),
    path("userUpdateProfile", views.userUpdateProfile),
    path("userUpdateProfileOtp", views.userUpdateProfileOtp),
    path("userChangePassword", views.userChangePassword),
    path("userGetDepots", views.userGetDepots),
    path("userGetPlaces", views.userGetPlaces),
    path("userGetInstitutions", views.userGetInstitutions),
    path("userGetCourses", views.userGetCourses),
    path("userApplyConcession", views.userApplyConcession),
    path("userGetApplications", views.userGetApplications),
    path("userGetApplication", views.userGetApplication),
    path("userDeleteApplication", views.userDeleteApplication),
    path("userPay", views.userPay),
    path("userGetCompletedApplications", views.userGetCompletedApplications),
    path("userGetCompletedApplication", views.userGetCompletedApplication),
    path("userDownloadConcession", views.userDownloadConcession),
]
