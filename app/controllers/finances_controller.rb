class FinancesController < ApplicationController
  def create
    session[:return_to] ||= request.referer

    @finance = Finance.new(finance_params)

    if @finance.save
      if @finance.charge
        Note.create(student_id: finance_params["student_id"], user_id: finance_params["user_id"], note: "Charge for #{'$%.2f' % finance_params['amount']} with note: '#{finance_params['note']}' was added.")
      else
        Note.create(student_id: finance_params["student_id"], user_id: finance_params["user_id"], note: "Credit for #{'$%.2f' % finance_params['amount']} with note: '#{finance_params['note']}' was added.")
      end

      redirect_to session.delete(:return_to), flash: {success: "Charge was created."}
    else
      redirect_to session.delete(:return_to), flash: {error: "Error: Cannot create a blank Charge."}
    end
  end

  def update
  end

  def destroy
    session[:return_to] ||= request.referer

    finance = Finance.find(params[:id])
    if finance.charge
      charge_or_credit = "Charge"
    else
      charge_or_credit = "Credit"
    end

    Note.create(student_id: finance.student_id, user_id: finance.user_id, note: "#{charge_or_credit} for #{'$%.2f' % finance.amount} with note: '#{finance.note}' was removed.")
    finance.destroy
    
    redirect_to session.delete(:return_to), flash: {success: "Charge/credit was removed."}
  end

  private

  def finance_params
    params.require(:finance).permit(:charge, :amount, :note, :student_id, :user_id)
  end
end
