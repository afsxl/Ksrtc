# Generated by Django 5.0.4 on 2024-04-27 10:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='concessionform',
            name='user',
        ),
        migrations.RemoveField(
            model_name='otp',
            name='user',
        ),
        migrations.AddField(
            model_name='concessionform',
            name='username',
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='otp',
            name='username',
            field=models.CharField(max_length=255, null=True),
        ),
    ]
