from django.db import models

# Create your models here.


class User(models.Model):
    name = models.CharField(max_length=255, null=True)
    username = models.CharField(max_length=255, primary_key=True)
    password = models.CharField(max_length=255, null=True)
    email = models.CharField(max_length=255, unique=True, null=True)


class Otp(models.Model):
    username = models.CharField(max_length=255, primary_key=True)
    otp = models.CharField(max_length=255, null=True)


class ConcessionForm(models.Model):
    username = models.CharField(max_length=255, null=True)
    name = models.CharField(max_length=255, null=True)
    photo = models.ImageField(upload_to="images/photo", null=True)
    id = models.ImageField(upload_to="images/id", null=True)
    aadhar = models.CharField(max_length=12, primary_key=True)
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
    hodApproval = models.IntegerField(default=0, null=True)
    institutionApproval = models.IntegerField(default=0, null=True)
    ksrtcApproval = models.IntegerField(default=0, null=True)
    front = models.ImageField(upload_to="files/front", null=True)
    back = models.ImageField(upload_to="files/back", null=True)
    cost = models.CharField(max_length=255, null=True)
    endDate = models.DateField(null=True)
