# require './config/environment'
# require 'dry/monads/maybe'
# require 'dry/monads/result'
# require 'dry/monads/try'
# require 'dry/monads/task'
# require 'dry/monads/do'
# require "dry/transaction"


# include Dry::Monads::Maybe::Mixin
# include Dry::Monads::Result::Mixin
# include Dry::Monads::Try::Mixin
# include Dry::Monads::Try::Task

####################################
class User
  # ...
end

# Other interfaces, not need to pass obj, pass state (what can be processed accordingly)
class Admin
  # ...
end

# class Service
#   def call(payload = {})
#     if valid?
#       # payload[:update] = true
#       # payload
#       User.new
#     else
#       { error: :invalid }
#     end
#   end

#   def valid?
#     # true
#     false
#   end
# end

# Success monad added
class Service
  def call(payload = {})
    if valid?
     Success(User.new)
    else
      Failure({ error: :invalid })
    end
  end

  def valid?
    # true
    false
  end
end

class NewService
  def call(payload = {})
    Success(User.new)
  end
end

result = NewService.new.call # => Resulting object
# (R.O./Success monad) is appopriate to multiservice binding
# if something chngd inside service, our changes in ResultingObject're minimal
if result.is_a?(User)
  puts 'Success'
else
  puts 'Failure'
end
# p Service.new.call
# p Service.new.call(something: :else)




##############TASK Monad###############
result = Task { Elastic.call(payload) } # mks/ms to proceed
psql_result = Task { Psql.call(payload) }
# go two different 2 services (2 async requests) and then union the results
result = Task { sleep 5; {} } # => 5 second not ended => Task(?)
# => Task(value={})
# like promises from JS
##############CASE Monad###############
case result
when Success
  puts 'Success'
when Failure { |error_type, _| error_type == :invalid }
  puts 'Failure: invalid'
when Failure { |error_type, _| error_type == :user_not_found }
  puts 'Failure: user_not_found'
end
# like gem for Rails gh/andypike/rectify ..call(Muh) do / on(:fail1) {Duh1} ...
# like case from gh/bvolshakov/fear library
# like dry-matcher (worse because it only works with blocks)
##############LIST Monad###############
#like bind, fmap, traverse, (tail head) list processing for values and state-monads like Result Maybe Success Failure
####################################
# Users.first # => User.new, nil
# user = Users.first
# user.try(:name) Users.first # => String, nil

# class Some
#   attr_reader :value
#   # Если бы использоватся dry-container, то использование этого конструктора было бы излишним
#   def initialize(value)
#     @value = value
#   end

#   def fmap(&block)
#     if value
#       self.class.new(block.call(value))
#     else
#       self.class.new(nil)
#     end
#   end
# end

# result = Some.new(User.first)
# new_result = result.fmap { &user.method(:name) } # => Some(user), Some(nil)
# # fmap - это bind-ящий fmap из dry-monad
# new_result.value

# # --- Null Object ---
# User
# NullUser
# User.new.method == NullUser.new.methods

# # ------------------ПРОВЕРКИ-----------------
# # if user
# #   address = user.address
# # end

# # if address
# #   city = address.city
# # end

# # if city
# #   state = city.state
# # end

# # if state
# #   state_name = state.name
# # end

# # user_state = state_name || "No state"

# user = some(User.find(params[:id]))
# user.fmap(&:address).fmap(&:city).fmap(&:state).fmap(&:name).value || "no state"

# # <=> But if key in arguments is absent rwhen you get ALL NULL
# # user.try(:address).try(:city).try(:state).try(:name).value || "no state"

# # <=> &.
# # ..............................

# # <=> .Maybe from dry-monads
# # ..............................
# # Some() and None() <=> Result's Success() and Failure()

# # ------------------------------------------------------
#  # <=> If new conditionitions added: BLOCKED_ADDRESSES = [....]
# # address = user.try(:address)
# #   if BLOCKED_ADDRESSES.include?(state.name)
# #     'No state'
# #   else
# #     address.try(:city).try(:state).try(:name).value || "no state"

# # <=> Result monad. fmap returns itself if condition true and bind returns its argument

# Success(user).bind { BLOCKED_ADDRESSES.include?(address.name) ? Failure("No state") : Success(address)
#                    }.fmap(&:city).fmap(&:state).fmap(&:name).value

#===========================
# authorisation by token.call
# yes no => R.O.
#   =>bind =>operation.call
#
# railway oriented programming
# bind-from-Scala, F#, dry-transaction (step :s1 ..., at the end easy .call it)
class CreateUser
  include Dry::Transaction

  step :validate
  step :call_service
  step :create

  private

  def validate(input)
    { payload: {} }
    # returns Success(valid_data) or Failure(validation)
  end

  #Added step-problem maker
  def call_service(input)
  	# inputting data and then these data we have to constantly passing from step to step:
    { payload: {}, service_data: {} }
    # returns Success(valid_data) or Failure(validation)
  end

  def create(input)
    { payload: {}, service_data: {} }
    # returns Success(user)
  end
end

# Around step - костыли в dry-transactions
# ...

include Dry::Monads::Do.for(:call)

def call(params)
	values = yield validate(params)
	owner_values = yield get_owner_values(values)
	# transaction do
	   #  account = yield create_account(values[:account])
	   #  owner = yield create_owner(account, owner_values)
	# end
	# Success([account, owner_values])
	account = yield create_account(values[:account])
	create_owner(create_owner(account, owner_values)
end

# Trailblazer-Operations + added forked logic!!!!
# Hanami-Interactor, but objects tough to collect

# Do notation continuation...
class User
end

# Yield works like conditional return
class Service
  include Dry::Monads::Do.for(:call)
  def call(payload = {})
    values = yield validate(params)

    account = yield create_account(values[:account])
	owner = yield create_owner(account, owner_values)
	Success([account, owner])
  end

  def validate(params)
    #Success(params)
    Failure(:invalid)
  end

  def create_account(account_values)
    Success(:account)
  end

  def create_owner(account, owner_values)
    Success(:owner)
  end
end

p Service.new.call(account: {}, owner: {})
