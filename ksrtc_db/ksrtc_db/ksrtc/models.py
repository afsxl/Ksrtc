from django.db import models
from user.models import User

# Create your models here.


class Concession(models.Model):
    username = models.CharField(max_length=255, null=True)
    name = models.CharField(max_length=255, null=True)
    photo = models.ImageField(upload_to="images/photo", null=True)
    idCard = models.ImageField(upload_to="images/id", null=True)
    aadhar = models.CharField(max_length=12, null=True)
    aadharFront = models.ImageField(upload_to="images/aadharFront", null=True)
    aadharBack = models.ImageField(upload_to="images/aadharBack", null=True)
    age = models.CharField(max_length=2, null=True)
    startPoint = models.CharField(max_length=255, null=True)
    endPoint = models.CharField(max_length=255, null=True)
    homeDistrict = models.CharField(max_length=255, null=True)
    depot = models.CharField(max_length=255, null=True)
    rate = models.CharField(max_length=2, null=True)
    district = models.CharField(max_length=255, null=True)
    place = models.CharField(max_length=255, null=True)
    institution = models.CharField(max_length=255, null=True)
    course = models.CharField(max_length=255, null=True)
    front = models.ImageField(upload_to="files/front", null=True)
    back = models.ImageField(upload_to="files/back", null=True)
    cost = models.CharField(max_length=255, null=True)
    endDate = models.DateField(null=True)


class Places(models.Model):
    district = models.CharField(max_length=255, null=True)
    place = models.CharField(max_length=255, null=True)


class Depots(models.Model):
    district = models.CharField(max_length=255, null=True)
    depot = models.CharField(max_length=255, null=True)
