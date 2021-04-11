# Generated by Django 3.2 on 2021-04-10 09:28

from django.db import migrations, models
import phonenumber_field.modelfields


class Migration(migrations.Migration):

    dependencies = [
        ('profile_app', '0007_alter_profile_age'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='gender',
            field=models.CharField(blank=True, choices=[('0', 'Male'), ('1', 'Female')], default=None, max_length=1),
        ),
        migrations.AlterField(
            model_name='profile',
            name='phone',
            field=phonenumber_field.modelfields.PhoneNumberField(blank=True, default=None, max_length=128, region=None, unique=True),
        ),
    ]