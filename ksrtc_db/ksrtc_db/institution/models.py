from django.db import models

# Create your models here.


class Institutions(models.Model):
    institution = models.CharField(max_length=255, null=True)
    district = models.CharField(max_length=255, null=True)
    place = models.CharField(max_length=255, null=True)
    password = models.CharField(max_length=255, null=True, default="pass123#")


class Courses(models.Model):
    institutionId = models.IntegerField(null=True)
    course = models.CharField(max_length=255, null=True)
    password = models.CharField(max_length=255, null=True)
