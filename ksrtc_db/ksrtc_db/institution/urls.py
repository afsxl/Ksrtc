from django.urls import path
from . import views

urlpatterns = [
    path("institutionCheckLogin", views.institutionCheckLogin),
    path("institutionGetPlaces", views.institutionGetPlaces),
    path("institutionGetInstitutions", views.institutionGetInstitutions),
    path("institutionSignin", views.institutionSignin),
    path("institutionGetProfile", views.institutionGetProfile),
    path("institutionChangePassword", views.institutionChangePassword),
    path("institutionGetApplications", views.institutionGetApplications),
    path("institutionGetApplication", views.institutionGetApplication),
    path("institutionRejectApplication", views.institutionRejectApplication),
    path("institutionApproveApplication", views.institutionApproveApplication),
    path("institutionAddCourse", views.institutionAddCourse),
    path("institutionGetCourses", views.institutionGetCourses),
    path("institutionDeleteCourse", views.institutionDeleteCourse),
]
