import random
import sqlite3
import string
from dataclasses import asdict, dataclass
from datetime import date, now

import numpy as np
from faker import Faker

fake = Faker()


class DatabaseManager:
    def __init__(self, db_name):
        self.conn = sqlite3.connect(db_name)
        self.cursor = self.conn.cursor()

    def insert_data(self, table_name, values):
        placeholders = ", ".join(["?"] * len(values))
        query = f"INSERT INTO {table_name} VALUES ({placeholders})"
        self.cursor.execute(query, values)
        self.conn.commit()

    def close_connection(self):
        self.conn.close()


CUSTOMER_TYPES = ["premium", "standard"]


@dataclass
class CustomerData:
    id: int
    email: str
    name: str
    date_of_birth: date
    phone: str
    address: str
    type: str
    loyalty_points: int


def generate_customer_data(id):
    customer_data = CustomerData(
        id=id,
        email=fake.email(),
        name=fake.name(),
        date_of_birth=fake.date_of_birth(),
        phone=fake.phone_number(),
        address=fake.address(),
        type=random.choice(CUSTOMER_TYPES),
        loyalty_points=random.randint(1, 100),
    )

    return list(asdict(customer_data).values())


@dataclass
class CardData:
    id: int
    customer_id: int
    card_number: str
    card_expiry: str
    card_cvv: str
    default: bool


def generate_cards(customer_id, default):
    card_data = CardData(
        id=random_with_N_digits(10),
        customer_id=customer_id,
        card_number=fake.credit_card_number(),
        card_expiry=fake.credit_card_expire(),
        card_cvv=fake.credit_card_security_code(),
        default=default,
    )
    return list(asdict(card_data).values())


def random_with_N_digits(n):
    range_start = 10 ** (n - 1)
    range_end = (10**n) - 1
    return random.randint(range_start, range_end)


@dataclass
class SellersData:
    code: str
    address: str
    name: str
    tax_id: str
    rating: float


def generate_seller_code():
    return "SEL" + str(random_with_N_digits(4))


def generate_sellers(seller_code):
    seller_data = SellersData(
        code=seller_code,
        address=fake.address(),
        name=fake.name(),
        tax_id=fake.ssn(),
        rating=random.randint(1, 500) / 100,
    )
    return list(asdict(seller_data).values())


@dataclass
class ProductData:
    id: int
    name: str
    description: str
    brand: str
    color: str
    dimensions: str
    weight: int
    price: int
    n_days_warranty: int
    category: str
    stock_count: int
    seller_id: int


def generate_products(product_id, seller_id):
    product_data = ProductData(
        id=product_id,
        name=fake.name(),
        description=fake.text(max_nb_chars=100),
        brand=fake.company(),
        color=fake.color_name(),
        dimensions=str(random.randint(1, 100))
        + "x"
        + str(random.randint(1, 100))
        + "x"
        + str(random.randint(1, 100))
        + "cm",
        weight=random.randint(1, 100),
        price=random.randint(1, 1000),
        n_days_warranty=random.randint(1, 100),
        category=random.choice(string.ascii_letters),
        stock_count=random.randint(1, 1000),
        seller_id=seller_id,
    )
    return list(asdict(product_data).values())


@dataclass
class ReviewData:
    id: int
    product_id: int
    rating: int
    comment: str


def generate_reviews(product_id):
    review_data = ReviewData(
        id=random_with_N_digits(10),
        product_id=product_id,
        rating=random.randint(1, 5),
        comment=fake.text(max_nb_chars=100),
    )
    return list(asdict(review_data).values())


@dataclass
class OrderData:
    id: int
    customer_id: int
    order_date: date
    payment_status: str
    amount_total: float


def generate_orders(customer_id, order_id):
    order_data = OrderData(
        id=order_id,
        customer_id=customer_id,
        order_date=fake.date_between(start_date="-2y", end_date="today"),
        payment_status=random.choice(["paid", "pending", "cancelled"]),
        amount_total=0,  # This will be calculated based on the products in the order
    )
    return list(asdict(order_data).values()), order_id


@dataclass
class BasketData:
    customer_id: int
    product_id: int
    quantity: int


def generate_baskets(customer_id, product_id):
    basket_data = BasketData(
        customer_id=customer_id, product_id=product_id, quantity=random.randint(1, 10)
    )
    return list(asdict(basket_data).values())


@dataclass
class OrderItemData:
    order_id: int
    product_id: int
    quantity: int


def generate_order_items(order_id, product_id):
    order_item_data = OrderItemData(
        order_id=order_id, product_id=product_id, quantity=random.randint(1, 10)
    )
    return list(asdict(order_item_data).values())


@dataclass
class DeliveryData:
    order_id: int
    tracking_number: int


def generate_delivery_data(order_id):
    delivery_data = DeliveryData(
        order_id=order_id, tracking_number=random_with_N_digits(5)
    )
    return list(asdict(delivery_data).values())


@dataclass
class ReturnData:
    id: int
    order_id: int
    ticket_number: int
    tracking_number: int
    start_date: date
    due_date: date
    refund_total: float
    status: str


def generate_return_data(id, order_id):
    return_data = ReturnData(
        id=id,
        order_id=order_id,
        ticket_number=random_with_N_digits(10),
        tracking_number=random_with_N_digits(5),
        start_date=fake.date_between(start_date="-30d", end_date="today"),
        due_date=fake.date_between(start_date="today", end_date="+30d"),
        refund_total=0.0,
        status=np.random.choice(["pending", "approved", "rejected"], p=[0.2, 0.7, 0.1]),
    )
    return list(asdict(return_data).values())


@dataclass
class ReturnItemsData:
    return_id: int
    quantity: int
    product_id: int


def generate_return_items_data(return_id, product_id):
    return_items_data = ReturnItemsData(
        return_id=return_id,
        quantity=1,  # Set as 1 for simplicity
        product_id=product_id,
    )
    return list(asdict(return_items_data).values())


@dataclass
class PaymentData:
    txn_id: int
    order_id: int
    amount: float
    status: str
    date: str


def generate_payment_data(payment_id, order_id):
    payment_data = PaymentData(
        txn_id=payment_id,
        order_id=order_id,
        amount=0,  # Will be set based on the order details
        status="pending",
        date=now().strftime("%Y-%m-%d %H:%M:%S"),
    )
    return list(asdict(payment_data).values())


def main():
    db = DatabaseManager("e-commerce.db")
    seen_customer_ids = set()
    seen_product_ids = set()
    seen_seller_ids = set()
    customers_with_orders = {}  # {(customer_id: [order_id_1, order_id_2, ..., order_id_n])}

    # populate customers
    for _ in range(100):
        customer_id = random_with_N_digits(10)
        if customer_id in seen_customer_ids:
            continue
        seen_customer_ids.add(customer_id)

        db.insert_data("customers", generate_customer_data(customer_id))

        # Set the first card as default for simplicity, in reality this would be determined by the customer's preference
        is_default = 1
        for _ in range(random.randint(1, 5)):
            db.insert_data("cards", generate_cards(customer_id, is_default))
            is_default = 0

        # populate orders
        for _ in range(random.randint(0, 5)):
            order_id = random_with_N_digits(10)
            order, order_id = generate_orders(customer_id, order_id)
            customers_with_orders[customer_id] = customers_with_orders.get(
                customer_id, []
            ) + [order_id]
            db.insert_data("orders", order)

            # populate payments
            txn_id = random_with_N_digits(10)
            payment, payment_id = generate_payment_data(txn_id, order_id)
            db.insert_data("payments", payment)

    # populate sellers and products
    for _ in range(10):
        seller_id = generate_seller_code()

        if seller_id in seen_seller_ids:
            continue
        seen_seller_ids.add(seller_id)

        seller_data = generate_sellers(seller_id)

        db.insert_data("sellers", seller_data)

        for _ in range(5):
            product_id = random_with_N_digits(5)
            if product_id in seen_product_ids:
                continue
            seen_product_ids.add(product_id)

            db.insert_data("products", generate_products(product_id, seller_id))

            # populate reviews
            for _ in range(random.randint(1, 10)):
                review_data = generate_reviews(product_id)
                db.insert_data("reviews", review_data)

    for customer_id in seen_customer_ids:
        random_product = random.choice(list(seen_product_ids))
        db.insert_data("basket", generate_baskets(customer_id, random_product))

    # populate order_items
    for customer_id, order_ids in customers_with_orders.items():
        ordered_products = []
        for order_id in order_ids:
            product_id = random.choice(list(seen_product_ids))
            order_items = generate_order_items(order_id, product_id)
            ordered_products.append(product_id)
            db.insert_data("order_items", order_items)

            # simulate 20% return rate
            if random.random() < 0.2:
                return_id = random_with_N_digits(5)
                db.insert_data("returns", generate_return_data(return_id, order_id))
                for product_id in ordered_products:
                    db.insert_data(
                        "return_items",
                        generate_return_items_data(return_id, product_id),
                    )
    db.close_connection()
    return


if __name__ == "__main__":
    main()
