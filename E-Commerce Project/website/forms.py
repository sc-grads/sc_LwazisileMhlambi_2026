from flask_wtf import FlaskForm 
from wtforms import StringField, IntegerField, FloatField, PasswordField, EmailField, BooleanField, SubmitField
from wtforms.validators import DataRequired, length, NumberRange


class SignUpForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired()])
    first_name = StringField('First Name', validators=[DataRequired()])
    last_name = StringField('Last Name', validators=[DataRequired()])
    password1 = PasswordField('Enter Your Password', validators=[DataRequired(), length(min=8)])
    password2 = PasswordField('Re-Enter Your Password', validators=[DataRequired(), length(min=8)])
    submit = SubmitField('Sign Up')

class LoginForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired()])
    password2 = PasswordField('Enter Your Password', validators=[DataRequired(), length(min=8)])
    submit = SubmitField('Log In')