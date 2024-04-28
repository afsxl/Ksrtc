from django.db import models


# Create your models here.
class Depots(models.Model):
    district = models.CharField(max_length=255, null=True)
    depot = models.CharField(max_length=255, null=True)
    password = models.CharField(max_length=255, default="pass@123")
