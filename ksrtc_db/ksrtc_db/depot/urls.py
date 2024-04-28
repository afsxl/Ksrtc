from django.urls import path
from . import views

urlpatterns = [
    path("depotCheckLogin", views.depotCheckLogin),
    path("depotGetDepots", views.depotGetDepots),
    path("depotSignin", views.depotSignin),
    path("depotGetProfile", views.depotGetProfile),
    path("depotChangePassword", views.depotChangePassword),
    path("depotGetApplications", views.depotGetApplications),
    path("depotGetApplication", views.depotGetApplication),
    path("depotRejectApplication", views.depotRejectApplication),
    path("depotApproveApplication", views.depotApproveApplication),
    path("depotGetCompletedApplications", views.depotGetCompletedApplications),
    path("depotGetCompletedApplication", views.depotGetCompletedApplication),
]
