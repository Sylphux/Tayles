class CheckoutController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]
  skip_before_action :redirect_home, only: [:webhook]

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
      metadata: {
        user_id: current_user.id
      }
    )

    redirect_to session.url, allow_other_host: true
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    Rails.logger.info "Stripe webhook received"
    
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      Rails.logger.error "Stripe webhook error: Invalid payload - #{e.message}"
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Stripe webhook error: Invalid signature - #{e.message}"
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    # Handle the checkout.session.completed event
    if event['type'] == 'checkout.session.completed'
      session = event['data']['object']
      user_id = session['metadata']['user_id']
      
      Rails.logger.info "Payment completed for user_id: #{user_id}"
      
      if user_id
        user = User.find_by(id: user_id)
        if user
          user.update(
            subscribed: true,
            subscription_end: 1.year.from_now
          )
          Rails.logger.info "User #{user.id} upgraded to premium until #{user.subscription_end}"
        else
          Rails.logger.error "User not found with id: #{user_id}"
        end
      else
        Rails.logger.error "No user_id in session metadata"
      end
    end

    render json: { status: 'success' }, status: 200
  end
end