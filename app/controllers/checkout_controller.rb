class CheckoutController < ApplicationController
  def create
    premium = Premium.first || Premium.new(name: 'Tayles Premium - Abonnement annuel', price_cents: 499)

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: premium.name,
          },
          unit_amount: premium.price_cents,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: root_url + "?success=true",
      cancel_url: root_url + "?canceled=true",
    )

    redirect_to session.url, allow_other_host: true
  end
end