# Generated by Django 5.0.4 on 2024-04-08 11:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='concessionform',
            name='back',
        ),
        migrations.RemoveField(
            model_name='concessionform',
            name='front',
        ),
        migrations.AddField(
            model_name='concessionform',
            name='concession',
            field=models.ImageField(null=True, upload_to='files'),
        ),
        migrations.AddField(
            model_name='concessionform',
            name='middlePoint1',
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='concessionform',
            name='middlePoint2',
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AddField(
            model_name='concessionform',
            name='middlePoint3',
            field=models.CharField(max_length=255, null=True),
        ),
    ]
