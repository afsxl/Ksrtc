from django.urls import path
from . import views

urlpatterns = [
    path("hodCheckLogin", views.hodCheckLogin),
    path("hodGetPlaces", views.hodGetPlaces),
    path("hodGetInstitutions", views.hodGetInstitutions),
    path("hodGetCourses", views.hodGetCourses),
    path("hodSignin", views.hodSignin),
    path("hodGetProfile", views.hodGetProfile),
    path("hodChangepassword", views.hodChangePassword),
    path("hodGetApplications", views.hodGetApplications),
    path("hodGetApplication", views.hodGetApplication),
    path("hodRejectApplication", views.hodRejectApplication),
    path("hodApproveApplication", views.hodApproveApplication),
]
