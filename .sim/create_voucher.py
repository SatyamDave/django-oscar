import datetime
from django.utils import timezone
from oscar.core.loading import get_model

Range = get_model("offer", "Range")
Benefit = get_model("offer", "Benefit")
Condition = get_model("offer", "Condition")
ConditionalOffer = get_model("offer", "ConditionalOffer")
Voucher = get_model("voucher", "Voucher")

# the sandbox site offers are exclusive and would block the voucher
ConditionalOffer.objects.filter(offer_type=ConditionalOffer.SITE).delete()
rng, _ = Range.objects.get_or_create(name="All products", defaults={"includes_all_products": True})
rng.includes_all_products = True
rng.save()
benefit = Benefit.objects.create(range=rng, type=Benefit.PERCENTAGE, value=10)
cond = Condition.objects.create(range=rng, type=Condition.COUNT, value=1)
offer = ConditionalOffer.objects.create(
    name="SAVE10", offer_type=ConditionalOffer.VOUCHER, benefit=benefit, condition=cond
)
now = timezone.now()
v = Voucher.objects.create(
    name="Save 10 percent", code="SAVE10", usage=Voucher.MULTI_USE,
    start_datetime=now - datetime.timedelta(days=1),
    end_datetime=now + datetime.timedelta(days=3650),
)
v.offers.add(offer)
print("voucher", v.code)
