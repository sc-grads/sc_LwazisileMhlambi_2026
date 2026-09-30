import os
import logging
import threading
from html import escape

import requests

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

BREVO_URL = "https://api.brevo.com/v3/smtp/email"
logger = logging.getLogger(__name__)


def _send_now(to_email, to_name, subject, html):
    api_key = os.environ.get("BREVO_API_KEY")
    sender_email = os.environ.get("BREVO_SENDER_EMAIL")
    sender_name = os.environ.get("BREVO_SENDER_NAME", "WeanerMart")

    if not api_key or not sender_email or not to_email:
        logger.warning("Email skipped: missing BREVO_API_KEY, BREVO_SENDER_EMAIL or recipient")
        return False

    try:
        response = requests.post(
            BREVO_URL,
            headers={
                "api-key": api_key,
                "Content-Type": "application/json",
                "accept": "application/json",
            },
            json={
                "sender": {"name": sender_name, "email": sender_email},
                "to": [{"email": to_email, "name": to_name or to_email}],
                "subject": subject,
                "htmlContent": html,
            },
            timeout=10,
        )
        if response.status_code >= 400:
            logger.error("Brevo error %s: %s", response.status_code, response.text)
            return False
        return True
    except requests.RequestException as e:
        logger.error("Brevo request failed: %s", e)
        return False


def send_email(to_email, to_name, subject, html):
    """Sends in a background thread so the checkout / admin request isn't slowed down.
    A failed email never raises, so it can never break an order."""
    threading.Thread(
        target=_send_now,
        args=(to_email, to_name, subject, html),
        daemon=True,
    ).start()


def get_buyer_details(data):
    """Reads the email and name the customer entered on the checkout form."""
    s = (data or {}).get("shipping_details") or {}
    return {"email": s.get("email"), "name": s.get("fullName")}


def send_order_confirmation(order_id, buyer, items, total, shipping):
    """
    items:    list of {"name": str, "quantity": int, "price": float}  (price = line total)
    shipping: the dict returned by get_shipping_fields()
    """
    rows = "".join(
        f"<tr>"
        f"<td style='padding:6px 0'>{escape(str(i['name']))} &times; {i['quantity']}</td>"
        f"<td style='padding:6px 0;text-align:right'>R{float(i['price']):.2f}</td>"
        f"</tr>"
        for i in items
    )

    address_parts = [
        shipping.get("shipping_address"),
        shipping.get("city"),
        shipping.get("province"),
        shipping.get("postal_code"),
    ]
    address = ", ".join(escape(str(p)) for p in address_parts if p)

    name = escape(buyer.get("name") or "there")
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:560px;margin:auto;color:#222">
      <h2>Thanks for your order, {name}!</h2>
      <p>Your payment was successful. Here is your order summary:</p>
      <p><strong>Order #{order_id}</strong></p>
      <table style="width:100%;border-collapse:collapse;border-top:1px solid #ddd;border-bottom:1px solid #ddd">
        {rows}
        <tr>
          <td style="padding:6px 0"><strong>Total (incl. delivery)</strong></td>
          <td style="padding:6px 0;text-align:right"><strong>R{float(total):.2f}</strong></td>
        </tr>
      </table>
      <p><strong>Delivering to:</strong><br>{address or 'No address provided'}</p>
      <p style="color:#777;font-size:12px">We'll email you again when your order status changes.</p>
    </div>
    """
    send_email(buyer.get("email"), buyer.get("name"), f"Order #{order_id} confirmed - WeanerMart", html)


STATUS_MESSAGES = {
    "processing": "We're preparing your order.",
    "shipped": "Good news, your order is on its way!",
    "delivered": "Your order has been delivered. We hope you enjoy it!",
    "cancelled": "Your order has been cancelled. If you have any questions, please contact us.",
}


def send_status_update(to_email, to_name, order_id, new_status):
    message = STATUS_MESSAGES.get(str(new_status).lower())
    if not message:
        return  # e.g. "Paid" - the purchase email already covers it

    name = escape(to_name or "there")
    html = f"""
    <div style="font-family:Arial,sans-serif;max-width:560px;margin:auto;color:#222">
      <h2>Order #{order_id} update</h2>
      <p>Hi {name},</p>
      <p>Your order status is now: <strong>{escape(str(new_status)).upper()}</strong></p>
      <p>{message}</p>
    </div>
    """
    send_email(to_email, to_name, f"Order #{order_id} is now {new_status} - WeanerMart", html)