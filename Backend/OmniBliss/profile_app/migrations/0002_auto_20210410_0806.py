# Generated by Django 3.2 on 2021-04-10 08:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('profile_app', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='profile',
            name='country',
        ),
        migrations.AddField(
            model_name='profile',
            name='hobbies',
            field=models.IntegerField(default=0),
        ),
    ]
