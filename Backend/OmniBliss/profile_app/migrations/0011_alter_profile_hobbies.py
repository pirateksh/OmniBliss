# Generated by Django 3.2 on 2021-04-10 09:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('profile_app', '0010_alter_profile_phone'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='hobbies',
            field=models.PositiveIntegerField(default=None, null=True),
        ),
    ]